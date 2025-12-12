import 'package:flutter/material.dart';

class FolderCategory {
  final String name;
  final Color color;
  final List<String> folders;

  const FolderCategory({
    required this.name,
    required this.color,
    required this.folders,
  });
}

const List<FolderCategory> folderStructure = [
  FolderCategory(
    name: 'Work',
    color: Color(0xFF3B82F6), // blue-500
    folders: ['Projects', 'Meetings', 'Client Notes'],
  ),
  FolderCategory(
    name: 'Personal',
    color: Color(0xFFA855F7), // purple-500
    folders: ['Learning', 'Ideas', 'Reading Notes'],
  ),
  FolderCategory(
    name: 'Archive',
    color: Color(0xFF6B7280), // gray-500
    folders: ['Old Projects'],
  ),
];
