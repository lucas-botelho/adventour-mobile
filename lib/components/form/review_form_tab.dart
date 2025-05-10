import 'dart:io';

import 'package:adventour/respositories/attraction_respository.dart';
import 'package:adventour/respositories/files_respository.dart';
import 'package:adventour/services/error_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'elements/text_box_input.dart';

class ReviewFormTab extends StatefulWidget {
  final int attractionId;

  final void Function(bool reviewCreated) callback;

  const ReviewFormTab(
      {super.key, required this.attractionId, required this.callback});

  @override
  State<ReviewFormTab> createState() => _ReviewFormTabState();
}

class _ReviewFormTabState extends State<ReviewFormTab> {
  final _formKey = GlobalKey<FormState>();
  int _rating = 0;
  final TextEditingController reviewController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final List<XFile> _selectedImages = [];
  Map<String, String> fieldErrors = {};

  late final AttractionRepository attractionRepository;
  late final FileRepository fileRepository;
  @override
  void initState() {
    super.initState();
    fileRepository = context.read<FileRepository>();
    attractionRepository = context.read<AttractionRepository>();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImages.add(image);
      });
    }
  }

  void _submitReview() async {
    if (_formKey.currentState!.validate()) {
      // _formKey.currentState!.save();
      String reviewText = reviewController.text;
      String titleText = titleController.text;

      //upload images to the server
      final List<File> filesToUpload =
          _selectedImages.map((xfile) => File(xfile.path)).toList();
      List<String> imagesUrls = [];
      var fileUploadResponse =
          await fileRepository.uploadMultipleFiles(files: filesToUpload);
      if (fileUploadResponse.success) {
        imagesUrls = fileUploadResponse.data?.files
                .map((file) => file.publicUrl)
                .toList() ??
            [];
      }

      var createReviewResponse = await attractionRepository.createReview(
        attractionId: widget.attractionId,
        review: reviewText,
        title: titleText,
        rating: _rating,
        imagesUrls: imagesUrls,
      );

      if (createReviewResponse?.statusCode != 200) {
        ErrorService().displayFieldErrors(context, createReviewResponse!.errors,
            (errors) {
          setState(() {
            fieldErrors = errors;
          });
        });
      }

      if (createReviewResponse?.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Thank you for leaving a review!")),
        );

        setState(() {
          _formKey.currentState!.reset();
          titleController.clear();
          reviewController.clear();
          _rating = 0;
          _selectedImages.clear();
          fieldErrors.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Thank you for leaving a review!")),
        );

        widget.callback(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const _textStyle = TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'Rambla',
        fontWeight: FontWeight.w700);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How would you rate your experience?",
              style: _textStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color: index < _rating ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () => setState(() => _rating = index + 1),
                );
              }),
            ),
            if (fieldErrors["Rating"] != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  fieldErrors["Rating"]!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontFamily: 'Rambla',
                  ),
                ),
              ),
            const SizedBox(height: 8),
            ReviewTextInput(
              controller: titleController,
              label: "Title your review",
              isMultiline: false,
              maxChars: 50,
              errorText: fieldErrors["Title"],
            ),
            const SizedBox(height: 8),
            ReviewTextInput(
                controller: reviewController,
                label: "Write your review",
                isMultiline: true,
                maxChars: 250,
                errorText: fieldErrors["Review"]),
            const SizedBox(height: 8),
            const Text(
              "Include some photos",
              style: _textStyle,
            ),
            const Text(
              "Optional",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 8),
            _imageSelectionWidget(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => widget.callback(false),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color(0xFF41969D),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _submitReview,
                  child: const Text("Submit Review"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _imageSelectionWidget() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: _selectedImages.isEmpty
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_outlined, size: 32, color: Colors.black54),
                  SizedBox(height: 4),
                  Text(
                    "Add photographs",
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              )
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ..._selectedImages.map(
                    (image) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(image.path),
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 2,
                            right: 2,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedImages.remove(image);
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black54,
                                ),
                                padding: const EdgeInsets.all(2),
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
