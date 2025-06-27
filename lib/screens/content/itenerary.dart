import 'dart:math' as math;

import 'package:adventour/components/cta/cta_button.dart';
import 'package:adventour/components/media/itinerary_header.dart';
import 'package:adventour/components/navigation/itinerary_builder_search_bar.dart';
import 'package:adventour/models/itinerary/day.dart';
import 'package:adventour/models/itinerary/itinerary.dart';
import 'package:adventour/models/itinerary/timeslot.dart';
import 'package:adventour/models/responses/attraction/basic_attraction_response.dart';
import 'package:adventour/respositories/attraction_respository.dart';
import 'package:adventour/respositories/itinerary_repository.dart';
import 'package:adventour/respositories/map_respository.dart';
import 'package:adventour/services/error_service.dart';
import 'package:adventour/services/geolocation_service.dart';
import 'package:flutter/material.dart';
import 'package:adventour/components/navigation/navbar.dart';
import 'package:provider/provider.dart';

class ItineraryPlanner extends StatefulWidget {
  final String countryCode;

  const ItineraryPlanner({super.key, required this.countryCode});

  @override
  State<ItineraryPlanner> createState() => _ItineraryPlannerState();
}

class _ItineraryPlannerState extends State<ItineraryPlanner> {
  // Constants
  final _headerHeightFactor = 0.32;

  //Placeholders
  String countryName = "Unknown Country";

  //Repositories
  late final GeolocationService geolocationService;
  late final AttractionRepository attractionRepository;
  late final ItineraryRepository itineraryRepository;
  late final MapRepository mapRepository;
  late final ErrorService errorService;

  late ItineraryModel selectedItinerary;
  List<ItineraryModel> itineraries =
      []; //itineraries list used on the dropdown and used for the login of submission
  List<BasicAttractionResponse> attractions =
      []; //attractions list used on the drawer

  //State variables
  List<int> selectedAttractions = [];
  int currentDayIndex = 0;
  Set<int> expandedDayIndexes = {0};

  @override
  initState() {
    super.initState();
    geolocationService = context.read<GeolocationService>();
    attractionRepository = context.read<AttractionRepository>();
    mapRepository = context.read<MapRepository>();
    itineraryRepository = context.read<ItineraryRepository>();
    errorService = context.read<ErrorService>();
    _fetchAttractions();
    _getCountryName();
    _fetchItineraries();

    // Initialize the new itinerary with one day and no timeslots
    itineraries = [
      ItineraryModel(
          id: null,
          name: 'New itinerary',
          days: [Day(dayNumber: 1, timeslots: [])]),
    ];
    selectedItinerary = itineraries.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      bottomNavigationBar: const NavBar(selectedIndex: 1),
      body: SizedBox.expand(
        child: Stack(
          children: [
            ItineraryHeaderImage(
                attractions: attractions,
                context: context,
                headerHeightFactor: _headerHeightFactor),
            // _buildCountryTitle(),
            _buildPlannerContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: CTAButton(
          text: "Save my itinerary",
          onPressed: _saveItinerary,
        ),
      ),
    );
  }

  Widget _buildConfirmSelectionButton(Day day) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CTAButton(
        text: "Confirm selection",
        onPressed: () {
          Navigator.pop(
            context,
            List<TimeSlot>.from(day.timeslots ?? []), // <- envia cópia da lista
          );
        },
      ),
    );
  }

  // Widget _buildCountryTitle() {
  //   return Positioned(
  //     top: MediaQuery.of(context).size.height * _headerHeightFactor / 2,
  //     child: Padding(
  //       padding: EdgeInsets.symmetric(
  //           horizontal: MediaQuery.of(context).size.height * _edgeInsetsFactor),
  //       child: Text(
  //         countryName,
  //         style: const TextStyle(
  //           fontSize: 28,
  //           fontWeight: FontWeight.bold,
  //           color: Colors.white,
  //           shadows: [
  //             Shadow(
  //               offset: Offset(1.5, 1.5), // posição da sombra
  //               blurRadius: 3.0,
  //               color: Colors.black54, // cor da sombra
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildPlannerContainer() {
    return Positioned(
      bottom: 0,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          color: Color(0xFF1B4D4B),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * (1 - _headerHeightFactor),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildContainerHeader(),
                const SizedBox(height: 12),
                ...List.generate(selectedItinerary.days!.length, (index) {
                  final day = selectedItinerary.days![index];
                  return _buildDayAccordion(day, index);
                }),
                const SizedBox(height: 16),
                _buildAddNewDayButton(),
                const SizedBox(height: 16),
                _buildCreateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewDayButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => {
          setState(() {
            selectedItinerary.days!.add(Day(
              dayNumber: selectedItinerary.days!.length + 1,
              timeslots: [],
            ));
            expandedDayIndexes.add(selectedItinerary.days!.length - 1);

          }),
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Day"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
    );
  }

  Widget _buildContainerHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Adventour Planner",
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(1.5, 1.5), // posição da sombra
                blurRadius: 3.0,
                color: Colors.black54, // cor da sombra
              ),
            ],
          ),
        ),
        _buildItineraryDropdown(),
      ],
    );
  }

  Widget _buildDayAccordion(Day day, int index) {
    return Dismissible(
      key: ValueKey(day.id ?? UniqueKey()), // <- chave única mesmo com títulos repetidos
      // <- chave única mesmo com títulos repetidos
      direction: DismissDirection.endToStart,
      dismissThresholds: const {
        DismissDirection.endToStart: 0.20,
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => _buildAlertDialog(context),
        );
      },
      onDismissed: (direction) {
        setState(() {
          selectedItinerary.days!.removeAt(index);
          expandedDayIndexes = expandedDayIndexes
              .where((i) => i != index)
              .map((i) => i > index ? i - 1 : i)
              .toSet();
          for (int i = 0; i < selectedItinerary.days!.length; i++) {
            selectedItinerary.days![i].dayNumber = i + 1;
          }

        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ExpansionTile(
          initiallyExpanded: expandedDayIndexes.contains(index),
          onExpansionChanged: (bool expanded) {
            setState(() {
              if (expanded) {
                expandedDayIndexes.add(index);
              } else {
                expandedDayIndexes.remove(index);
              }
            });
          },
          title: Text("Day ${day.dayNumber.toString()}",
              style: const TextStyle(fontWeight: FontWeight.w400)),
          children: [
            ...((day.timeslots ?? [])
                    .where((slot) => slot.attraction != null)
                    .toList()
                  ..sort((a, b) {
                    final startComparison = a.startTime.compareTo(b.startTime);
                    return startComparison != 0
                        ? startComparison
                        : a.endTime.compareTo(b.endTime);
                  }))
                .map((slot) {
              return ListTile(
                title: Text(slot.attraction!.name),
                subtitle: Text(
                    '${formatTime(slot.startTime)} - ${formatTime(slot.endTime)}'),
                trailing: const Icon(Icons.directions),
              );
            }),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.settings),
                  label: const Text("Manage activities"),
                  onPressed: () {
                    _showAttractionDrawer(day);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttractionDrawer(Day day) async {
    String searchQuery = '';

    final result = await showModalBottomSheet<List<TimeSlot>>(
      // <- Resultado será lista de TimeSlot
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1B4D4B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.8,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Select an activity",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                      ItineraryBuilderSearchBar(onChanged: (value) {
                        setModalState(() {
                          searchQuery = value.toLowerCase();
                        });
                      }),
                      const SizedBox(height: 16),
                      _buildDrawerModal(
                        scrollController,
                        setModalState,
                        searchQuery,
                        day,
                      ),
                      _buildConfirmSelectionButton(day)
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        final index = selectedItinerary.days!.indexOf(day);
        selectedItinerary.days![index] = Day(
          dayNumber: day.dayNumber,
          timeslots: result,
        );
      });
    }
  }

  Widget _buildDrawerModal(
    ScrollController scrollController,
    StateSetter setModalState,
    String searchQuery,
    Day day,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardSize = (screenWidth - 48) / 2;

    final filteredAttractions = attractions
        .where((a) => a.name.toLowerCase().contains(searchQuery))
        .toList();

    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: filteredAttractions.map((attraction) {
            final isSelected =
                day.timeslots!.any((t) => t.attraction!.id == attraction.id);
            return Stack(
              children: [
                SizedBox(
                  width: cardSize,
                  height: cardSize,
                  child: _buildAttractionCard(attraction),
                ),
                _buildCardPlusButton(context, setModalState, isSelected,
                    attraction, screenWidth, day),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCardPlusButton(
    BuildContext context,
    StateSetter setModalState,
    bool isSelected,
    BasicAttractionResponse attraction,
    double screenWidth,
    Day day,
  ) {
    return Positioned(
      top: 8,
      right: 8,
      child: GestureDetector(
        onTap: () async {
          if (!isSelected) {
            final selectedTimes = await showDialog<Map<String, TimeOfDay>>(
              context: context,
              barrierDismissible: false,
              builder: (_) => _buildTimeSlotDialog(context, attraction.name),
            );

            if (selectedTimes != null) {
              final startTime = selectedTimes['start']!;
              final endTime = selectedTimes['end']!;

              setModalState(() {
                day.timeslots = List<TimeSlot>.from(day.timeslots ?? [])
                  ..add(TimeSlot(
                    name: attraction.name,
                    attraction: attraction,
                    startTime: timeOfDayToDateTime(startTime),
                    endTime: timeOfDayToDateTime(endTime),
                    attractionId: attraction.id,
                  ));
              });
            }
          } else {
            setModalState(() {
              day.timeslots = List<TimeSlot>.from(day.timeslots ?? [])
                ..removeWhere((t) => t.attractionId == attraction.id);
            });
          }
        },
        child: Container(
          width: math.max(5.0, screenWidth * 0.06),
          height: math.max(5.0, screenWidth * 0.06),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green[200] : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(
              isSelected ? Icons.check : Icons.add,
              size: math.max(5.0, screenWidth * 0.06) * 0.6,
              color: isSelected ? Colors.green : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildTimeSlotDialog(BuildContext dialogContext, String attractionName) {
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    String? errorText; // <-- Guarda a mensagem de erro

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text('Schedule your visit to $attractionName!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: dialogContext,
                    initialTime: TimeOfDay.now(),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                            ),
                          ),
                          textTheme: Theme.of(context).primaryTextTheme.copyWith(
                            bodyLarge: const TextStyle(color: Colors.black),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      startTime = picked;
                      errorText = null; // limpa o erro ao selecionar nova hora
                    });
                  }
                },
                child: Text(startTime != null
                    ? 'Start: ${startTime!.format(context)}'
                    : 'Starting time'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: dialogContext,
                    initialTime: TimeOfDay.now(),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                            ),
                          ),
                          textTheme: Theme.of(context).primaryTextTheme.copyWith(
                            bodyLarge: const TextStyle(color: Colors.black),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      endTime = picked;
                      errorText = null;
                    });
                  }
                },
                child: Text(endTime != null
                    ? 'End: ${endTime!.format(context)}'
                    : 'Ending time'),
              ),
              if (errorText != null) ...[
                const SizedBox(height: 10),
                Text(
                  errorText!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (startTime == null || endTime == null) return;

                    if (endTime!.hour > startTime!.hour ||
                        (endTime!.hour == startTime!.hour &&
                            endTime!.minute > startTime!.minute)) {
                      Navigator.pop(dialogContext, {
                        'start': startTime!,
                        'end': endTime!,
                      });
                    } else {
                      setState(() {
                        errorText = 'End time must be after start time.';
                      });
                    }
                  },
                  child: const Text('Confirm'),
                ),
              ],
            )
          ],
        );
      },
    );
  }


  Widget _buildAlertDialog(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Remove this day?",
        style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
      ),
      content: const Text(
        "This action cannot be undone.",
        style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
      ),
      backgroundColor: Colors.white,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Cancel",
              style: TextStyle(color: Colors.black, fontFamily: 'Poppins')),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Remove",
              style: TextStyle(color: Colors.red, fontFamily: 'Poppins')),
        ),
      ],
    );
  }

  Widget _buildItineraryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: _buildDropdownButton(),
      ),
    );
  }

  Widget _buildDropdownButton() {
    return PopupMenuButton<ItineraryModel>(
      tooltip: 'Select itinerary',
      itemBuilder: (context) => itineraries.map((item) {
        return PopupMenuItem<ItineraryModel>(
          value: item,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.name!,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (item.id != null) //nao mostrar para o novo
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 24),
                  onPressed: () {
                    Navigator.pop(context);
                    _deleteItinerary(item);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        );
      }).toList(),
      onSelected: (ItineraryModel selected) {
        setState(() {
          selectedItinerary = selected;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedItinerary.name ?? 'Select itinerary',
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildAttractionCard(BasicAttractionResponse attraction) {
    final imageUrl = attraction.attractionImages.isNotEmpty
        ? attraction.attractionImages.first.url
        : 'assets/images/step_two_image.jpg';

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(imageUrl, fit: BoxFit.cover),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black54, Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attraction.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                if (attraction.rating != null)
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        attraction.rating!.toStringAsFixed(1),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _getCountryName() async {
    final countryData = await mapRepository.getCountry(widget.countryCode);
    if (countryData != null && countryData.data != null) {
      countryName = countryData.data!.name;
    }
  }

  void _fetchAttractions() async {
    try {
      final response = await attractionRepository.getAttractions(
        countryCode: widget.countryCode,
      );

      if (response != null && response.data != null) {
        setState(() {
          attractions = response.data!.attractions;
        });
      } else {
        errorService.displaySnackbarError(context, response?.message);
      }
    } catch (e) {
      errorService.displaySnackbarError(context,
          'There was an error loading the attractions for this country');
    }
  }

  void _saveItinerary() async {
    final TextEditingController nameController = TextEditingController(
      text: selectedItinerary.name, // já pré-preenche com o nome atual, se existir
    );

    // Mostra o modal para introduzir ou editar o nome
    final bool confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Name your itinerary'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Enter itinerary name'),
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  Navigator.of(context).pop(true);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    ) ??
        false;

    if (!confirmed) return;

    // Define o nome no objeto antes de guardar
    selectedItinerary.name = nameController.text.trim();

    // Verifica se vai criar ou atualizar
    final response = selectedItinerary.id == null
        ? await itineraryRepository.saveItinerary(selectedItinerary)
        : await itineraryRepository.updateItinerary(selectedItinerary);

    if (response != null && response.success && response.data != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          selectedItinerary.id == null
              ? 'Itinerary created successfully'
              : 'Itinerary updated successfully',
        )),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response?.message ?? 'Failed to save itinerary'),
        ),
      );
    }
  }


  void _fetchItineraries() async {
    final response =
        await itineraryRepository.getItineraries(widget.countryCode);

    if (response != null && response.success && response.data != null) {
      setState(() {
        itineraries.addAll(response.data!.itineraries);
      });
    } else {
      errorService.displaySnackbarError(context, response?.message);
    }
  }

  String formatTime(DateTime dateTime) {
    final time = TimeOfDay.fromDateTime(dateTime);
    return time.format(context);
  }

  void _deleteItinerary(ItineraryModel item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm delete"),
        content:
            Text("Are you sure you want to delete itinerary '${item.name}'?", style: TextStyle(color: Colors.black),),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final response = await itineraryRepository.deleteItinerary(item.id!);

    if (response != null && response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(response.data ?? 'Itinerary deleted successfully.')),
      );

      setState(() {
        itineraries.removeWhere((i) => i.id == item.id);
        if (selectedItinerary.id == item.id && itineraries.isNotEmpty) {
          selectedItinerary = itineraries.first;
        } else if (itineraries.isEmpty) {
          itineraries = [
            ItineraryModel(
                id: null,
                name: 'New itinerary',
                days: [Day(dayNumber: 1, timeslots: [])]),
          ];
          selectedItinerary = itineraries.first;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(response?.message ?? 'Failed to delete itinerary.')),
      );
    }
  }

  DateTime timeOfDayToDateTime(TimeOfDay tod) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  }
}
