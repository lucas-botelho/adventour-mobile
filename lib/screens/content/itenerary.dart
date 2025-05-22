import 'dart:math' as math;

import 'package:adventour/components/cta/cta_button.dart';
import 'package:adventour/models/responses/attraction/basic_attraction_response.dart';
import 'package:adventour/respositories/attraction_respository.dart';
import 'package:adventour/respositories/map_respository.dart';
import 'package:adventour/screens/world_map.dart';
import 'package:adventour/services/geolocation_service.dart';
import 'package:flutter/material.dart';
import 'package:adventour/components/navigation/navbar.dart';
import 'package:provider/provider.dart';

class IteneraryPlanner extends StatefulWidget {
  final String countryCode;

  const IteneraryPlanner({super.key, required this.countryCode});

  @override
  State<IteneraryPlanner> createState() => _IteneraryPlannerState();
}

class _IteneraryPlannerState extends State<IteneraryPlanner> {
  final _headerHeightFactor = 0.32;
  final _edgeInsetsFactor = 0.03;
  final List<int> selectedAttractions = [];
  late final GeolocationService geolocationService;
  late final AttractionRepository attractionRepository;
  late final MapRepository mapRepository;
  late ItineraryOption selectedItinerary;
  late List<ItineraryOption> availableItineraries;
  String countryName = "Unknown Country";
  List<DayItinerary> itineraryDays = [
    DayItinerary(dayTitle: "Day 1", slots: [
      TimeSlot(time: "08:00 - 12:00", title: "Auberge Djoni"),
      TimeSlot(time: "12:00 - 13:00", title: "Le Manur Restaurant"),
    ]),
  ];

  List<DayItinerary> itineraryDays2 = [
    DayItinerary(dayTitle: "Day 1", slots: [
      TimeSlot(time: "08:00 - 12:00", title: "Auberge Djoni"),
      TimeSlot(time: "12:00 - 13:00", title: "Le Manur Restaurant"),
    ]),
    DayItinerary(dayTitle: "Day 2", slots: [
      TimeSlot(time: "08:00 - 12:00", title: "Auberge Djoni"),
      TimeSlot(time: "12:00 - 13:00", title: "Le Manur Restaurant"),
    ]),
  ];



  List<BasicAttractionResponse> attractions = [];

  @override
  initState() {
    super.initState();
    geolocationService = context.read<GeolocationService>();
    attractionRepository = context.read<AttractionRepository>();
    mapRepository = context.read<MapRepository>();
    _fetchAttractions();
    _getCountryName();

    availableItineraries = [
      ItineraryOption(id: null, name: 'My sakura'),
      ItineraryOption(id: 1, name: 'Weekend Trip'),
      ItineraryOption(id: 2, name: 'Favorites'),
    ];

    selectedItinerary = availableItineraries.first;
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
            _buildHeaderImage(),
            _buildCountryTitle(),
            _buildPlannerContainer(),
          ],
        ),
      ),
    );
  }

  Future<void> _getCountryName() async {
    final countryData = await mapRepository.getCountry(widget.countryCode);
    if (countryData != null && countryData.data != null) {
      countryName = countryData.data!.name;
    }
  }

  Future<void> _fetchAttractions() async {
    try {
      final response = await attractionRepository.getAttractions(
        countryCode: widget.countryCode,
      );

      if (response != null && response.data != null) {
        setState(() {
          attractions = response.data!.attractions;
        });
      } else {
        // debugPrint("No attractions found for country code: $currentCountryCode");
      }
    } catch (e) {
      debugPrint("Error fetching attractions: $e");
    } finally {
      // setState(() => isLoading = false); // Stop loading
    }
  }

  Widget _buildCreateButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: CTAButton(
          text: "Save my itinerary",
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdventourMap(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmSelectionButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CTAButton(
        text: "Confirm selection",
        onPressed: () => {},
      ),
    );
  }

  Widget _buildCountryTitle() {
    return Positioned(
      top: MediaQuery.of(context).size.height * _headerHeightFactor / 2,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.height * _edgeInsetsFactor),
        child: Text(
          countryName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
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
      ),
    );
  }

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
                ...List.generate(itineraryDays.length, (index) {
                  final day = itineraryDays[index];
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
        onPressed: _addNewDay,
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

  void _addNewDay() {
    //todo: fazer post para criar dia na base de dados

    setState(() {
      itineraryDays.add(
        DayItinerary(
          dayTitle: "Day ${itineraryDays.length + 1}",
          slots: [],
        ),
      );
    });
  }

  Widget _buildDayAccordion(DayItinerary day, int index) {
    return Dismissible(
      key: ValueKey('day-$index'), // <- chave única mesmo com títulos repetidos
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
          itineraryDays.removeAt(index);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ExpansionTile(
          title: Text(day.dayTitle,
              style: const TextStyle(fontWeight: FontWeight.w400)),
          children: [
            ...day.slots.map((slot) {
              return ListTile(
                title: Text(slot.title),
                subtitle: Text(slot.time),
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
                  icon: const Icon(Icons.add),
                  label: const Text("Add activity"),
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


  void _showAttractionDrawer(DayItinerary day) {
    //Mantido fora do builder para não reiniciar a cada setModalState
    String searchQuery = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1B4D4B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final cardSize = (screenWidth - 48) / 2;

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
                      _buildAttractionDrawerDragLine(context),
                      const SizedBox(height: 12),
                      _buildDrawerTitle(),
                      _buildSearchBar((value) {
                        setModalState(() {
                          searchQuery = value.toLowerCase();
                        });
                      }),
                      const SizedBox(height: 16),
                      _buildDrawerScrollableContent(
                        scrollController,
                        cardSize,
                        setModalState,
                        screenWidth,
                        searchQuery, //Passa a query
                      ),
                      _buildConfirmSelectionButton()
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSearchBar(ValueSetter<String> onChanged) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search attractions...',
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: const Icon(Icons.search, color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDrawerScrollableContent(
    ScrollController scrollController,
    double cardSize,
    StateSetter setModalState,
    double screenWidth,
    String searchQuery,
  ) {
    // Filtra as atrações com base na query de pesquisa
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
            final isSelected = selectedAttractions.contains(attraction.id);
            return Stack(
              children: [
                SizedBox(
                  width: cardSize,
                  height: cardSize,
                  child: _buildAttractionCard(attraction),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      setModalState(() {
                        if (isSelected) {
                          selectedAttractions.remove(attraction.id);
                        } else {
                          selectedAttractions.add(attraction.id);
                        }
                      });
                    },
                    child: Container(
                      width: math.max(5.0, screenWidth * 0.06),
                      height: math.max(5.0, screenWidth * 0.06),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? Colors.green[200] : Colors.grey[200],
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
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDrawerTitle() {
    return const Text(
      "Select an activity",
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white),
    );
  }

  Widget _buildAttractionDrawerDragLine(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.1,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
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
    return DropdownButton<ItineraryOption>(
      value: selectedItinerary,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      dropdownColor: Colors.white,
      items: availableItineraries.map<DropdownMenuItem<ItineraryOption>>((item) {
        return DropdownMenuItem<ItineraryOption>(
          value: item,
          child: Text(item.name),
        );
      }).toList(),
      onChanged: (ItineraryOption? value) {
        if (value != null) {
          debugPrint("Selected itinerary: ${value.name} and id: ${value.id}");

          setState(() {
            itineraryDays = itineraryDays2;
            selectedItinerary = value;
          });
        }
      },
    )
    ;
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
          _buildPlusButtonOnAttractionCard(attraction),
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

  Widget _buildPlusButtonOnAttractionCard(BasicAttractionResponse attraction) {
    final screenWidth = MediaQuery.of(context).size.width;
    final plusButtonSize = math.max(5.0, screenWidth * 0.06);
    final isSelected = selectedAttractions.contains(attraction.id);

    return Positioned(
      top: 8,
      right: 8,
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (!isSelected) {
              selectedAttractions.add(attraction.id);
            } else {
              selectedAttractions.remove(attraction.id);
            }
          });
        },
        child: Container(
          width: plusButtonSize,
          height: plusButtonSize,
          decoration: BoxDecoration(
            color: isSelected ? Colors.green[200] : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(isSelected ? Icons.check : Icons.add,
                size: plusButtonSize * 0.6,
                color: isSelected ? Colors.green : Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    String? imageUrl;

    if (attractions.isNotEmpty &&
        attractions.first.attractionImages.isNotEmpty) {
      imageUrl = attractions.first.attractionImages.first.url;
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * _headerHeightFactor,
      width: double.infinity,
      child: imageUrl != null
          ? Image.network(imageUrl, fit: BoxFit.cover)
          : Image.asset('assets/images/step_two_image.jpg', fit: BoxFit.cover),
    );
  }
}

class TimeSlot {
  final String time;
  final String title;

  TimeSlot({required this.time, required this.title});
}

class DayItinerary {
  final String dayTitle;
  final List<TimeSlot> slots;

  DayItinerary({required this.dayTitle, required this.slots});
}

class ItineraryOption {
  final int? id; // pode ser null para novos itinerários
  final String name;

  ItineraryOption({this.id, required this.name});
}

