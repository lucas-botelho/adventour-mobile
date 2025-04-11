import 'package:adventour/components/layout/content_appbar.dart';
import 'package:adventour/components/media/attraction_image_slider.dart';
import 'package:adventour/components/navigation/attraction_nav.dart';
import 'package:adventour/components/navigation/navbar.dart';
import 'package:adventour/components/navigation/sidemenu.dart';
import 'package:adventour/models/responses/attraction/attraction_response.dart';
import 'package:adventour/respositories/attraction_respository.dart';
import 'package:flutter/material.dart';

class AttractionDetails extends StatefulWidget {
  final int id;

  const AttractionDetails({super.key, required this.id});

  @override
  State<AttractionDetails> createState() => _AttractionDetailsState();
}

class _AttractionDetailsState extends State<AttractionDetails> {
  bool isLoading = true;
  AttractionResponse? attractionDetails;
  String? errorMessage;
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _fetchAttractionDetails();
  }

  Future<void> _fetchAttractionDetails() async {
    setState(() => isLoading = true); // Start loading

    try {
      var response = await AttractionRespository().getAttraction(widget.id);

      if (response == null) {
        setState(() {
          errorMessage = 'No attraction details found.';
        });
        return;
      }

      setState(() {
        attractionDetails = response.data;
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load attraction details: $e';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Text(errorMessage!),
      );
    }

    if (attractionDetails == null) {
      return const Center(
        child: Text('No details available for this attraction.'),
      );
    }

    return Scaffold(
      appBar: ContentAppbar(title: attractionDetails!.name),
      drawer: const SideMenu(),
      bottomNavigationBar: NavBar(
        selectedIndex: 0,
        onItemTapped: (index) => debugPrint("Tapped on index: $index"),
      ),
      body: Column(
        children: [
          AttractionNav(
            selectedIndex: selectedTab,
            onTabSelected: (index) {
              setState(() {
                selectedTab = index;
              });
            },
          ),
          Expanded(
            child: IndexedStack(
              index: selectedTab,
              children: [
                aboutTab(context),
                informationTab(),
                evaluationsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Center evaluationsTab() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'User reviews and evaluations will go here.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Center informationTab() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Information about the attraction will go here.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  SingleChildScrollView aboutTab(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AttractionImageSlider(
            imageUrls: attractionDetails!.attractionImages
                .map((image) => image.url)
                .toList(),
          ),
          _label(),
          description(context),
        ],
      ),
    );
  }

  Padding description(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 30, 128, 129),
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Text(
            attractionDetails!.longDescription != null
                ? attractionDetails!.longDescription!
                : 'No details available for this attraction.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Padding _label() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Center(
        child: Text(
          'Photos/Videos',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
