// lib/features/portofolio/widgets/project_links_section.dart
import 'package:flutter/material.dart';
import 'package:mb/data/entities/project_entity.dart';
import 'package:mb/features/project/widgets/project_section_header.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectLinksSection extends StatelessWidget {
  final ProjectEntity project;
  final Color themeColor;

  const ProjectLinksSection({
    Key? key,
    required this.project,
    required this.themeColor,
  }) : super(key: key);

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  String _getLinkDisplayName(String url) {
    try {
      final Uri uri = Uri.parse(url);
      final String host = uri.host;

      // Clean up the host name
      if (host.startsWith('www.')) {
        return host.substring(4);
      }
      return host;
    } catch (e) {
      // Fallback if URL parsing fails
      return "External Link";
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> linkButtons = [];

    // Main project link
    if (project.link.isNotEmpty) {
      linkButtons.add(
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          child: ElevatedButton.icon(
            onPressed: () => _launchURL(project.link),
            icon: const Icon(Icons.open_in_new_rounded, size: 20),
            label: const Text("Visit Project"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: themeColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      );
    }

    // GitHub link
    if (project.githubLink != null) {
      linkButtons.add(
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          child: OutlinedButton.icon(
            onPressed: () => _launchURL(project.githubLink!),
            icon: const Icon(Icons.code, size: 20),
            label: const Text("View Source Code"),
            style: OutlinedButton.styleFrom(
              foregroundColor: themeColor,
              side: BorderSide(color: themeColor),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      );
    }

    // Additional links
    if (project.additionalLinks != null &&
        project.additionalLinks!.isNotEmpty) {
      for (int i = 0; i < project.additionalLinks!.length; i++) {
        final String link = project.additionalLinks![i];
        final String linkName = _getLinkDisplayName(link);

        linkButtons.add(
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            child: OutlinedButton.icon(
              onPressed: () => _launchURL(link),
              icon: const Icon(Icons.link, size: 20),
              label: Text(linkName),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
                side: BorderSide(color: Colors.grey.shade300),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        );
      }
    }

    if (linkButtons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSectionHeader(
          icon: Icons.link_rounded,
          title: "Links",
          themeColor: themeColor,
        ),
        const SizedBox(height: 16),
        ...linkButtons,
      ],
    );
  }
}
