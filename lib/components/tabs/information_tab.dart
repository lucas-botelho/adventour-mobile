import 'package:adventour/components/text/accordion.dart';
import 'package:adventour/models/responses/attraction/attraction_info_data_response.dart';
import 'package:adventour/respositories/attraction_respository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InformationTabs extends StatefulWidget {
  final int attractionId;

  const InformationTabs({super.key, required this.attractionId});

  @override
  _InformationTabsState createState() => _InformationTabsState();
}

class _InformationTabsState extends State<InformationTabs> {
  int _currentPage = 0;
  Future<AttractionInfoDataResponse?>? _futureResponse;
  late final AttractionRepository attractionRepository;

  @override
  void initState() {
    super.initState();
    attractionRepository = context.read<AttractionRepository>();
    _futureResponse =
        attractionRepository.getAttractionInfo(widget.attractionId).then(
              (response) => response?.data,
            );
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  void _goToNextPage(int totalPages) {
    if (_currentPage < totalPages - 1) {
      setState(() {
        _currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AttractionInfoDataResponse?>(
      future: _futureResponse,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("No information available."));
        }

        final infoData = snapshot.data!;
        final pages = infoData.infoTypes.map((infoType) {
          final infos = infoData.attractionInfos
              .where((i) => i.attractionInfoTypeId == infoType.id)
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 17),
                child: Text(
                  infoType.typeTitle,
                  style: const TextStyle(
                    fontFamily: 'PoetessOne',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              ...infos.map((info) => Accordion(
                    title: info.title,
                    description: info.description,
                  )),
            ],
          );
        }).toList();

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: pages[_currentPage],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentPage > 0
                      ? TextButton(
                          onPressed: _goToPreviousPage,
                          child: const Text("< Back"),
                        )
                      : const SizedBox(),
                  _currentPage < pages.length - 1
                      ? TextButton(
                          onPressed: () => _goToNextPage(pages.length),
                          child: const Text("Next >"),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
