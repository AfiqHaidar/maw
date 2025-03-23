import 'package:flutter/material.dart';
import 'package:mb/data/models/project_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectSheet extends StatefulWidget {
  final double sheetAnimation;
  final double fadeAnimation;
  final double sheetHeight;
  final ProjectModel project;
  final int itemIndex;
  final VoidCallback onClose;

  const ProjectSheet({
    Key? key,
    required this.sheetAnimation,
    required this.fadeAnimation,
    required this.sheetHeight,
    required this.project,
    required this.itemIndex,
    required this.onClose,
  }) : super(key: key);

  @override
  State<ProjectSheet> createState() => _ProjectSheetState();
}

class _ProjectSheetState extends State<ProjectSheet> {
  late DraggableScrollableController _dragController;
  late PageController _carouselController;
  int _currentPage = 0;
  bool _showMoreDetails = false;

  @override
  void initState() {
    super.initState();
    _dragController = DraggableScrollableController();
    _carouselController = PageController();
    _carouselController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final page = _carouselController.page?.round() ?? 0;
    if (page != _currentPage) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  String _getLastName(String fullName) {
    final parts = fullName.trim().split(' ');
    return parts.isNotEmpty ? parts.last : fullName;
  }

  @override
  void dispose() {
    _dragController.dispose();
    _carouselController.removeListener(_onPageChanged);
    _carouselController.dispose();
    super.dispose();
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final themeColor = widget.project.bannerBgColor;

    final minFraction = 0.55;
    final maxFraction = widget.sheetHeight / screenHeight;
    final initialFraction = maxFraction;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: screenHeight,
      child: Stack(
        children: [
          // Bottom sheet
          AnimatedSlide(
            offset: Offset(0, 1 - widget.sheetAnimation),
            duration: const Duration(milliseconds: 150),
            child: DraggableScrollableSheet(
              initialChildSize: initialFraction,
              minChildSize: minFraction,
              maxChildSize: maxFraction,
              controller: _dragController,
              snap: true,
              snapSizes: [minFraction, maxFraction],
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.15 * widget.fadeAnimation),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle and close button row
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Project date
                            if (widget.project.releaseDate != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  '${widget.project.releaseDate!.year}/${widget.project.releaseDate!.month.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              )
                            else
                              const SizedBox(width: 40),

                            // Handle bar
                            Container(
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),

                            // Close button
                            GestureDetector(
                              onTap: widget.onClose,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 22,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Scrollable content
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          physics: const BouncingScrollPhysics(),
                          children: [
                            const SizedBox(height: 16),

                            // Project title
                            Text(
                              widget.project.name,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),

                            // Short description
                            if (widget.project.shortDescription != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                widget.project.shortDescription!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],

                            // Role and Development time
                            if (widget.project.role != null ||
                                widget.project.developmentTime != null) ...[
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 16,
                                children: [
                                  if (widget.project.role != null)
                                    _buildInfoChip(
                                      Icons.person_outline_rounded,
                                      widget.project.role!,
                                      themeColor,
                                    ),
                                  if (widget.project.developmentTime != null)
                                    _buildInfoChip(
                                      Icons.calendar_today_rounded,
                                      "${widget.project.developmentTime!.inDays} days",
                                      themeColor,
                                    ),
                                ],
                              ),
                            ],

                            const SizedBox(height: 20),

                            // Image Carousel
                            if (widget
                                .project.carouselImagePaths.isNotEmpty) ...[
                              SizedBox(
                                height: 220,
                                child: Stack(
                                  children: [
                                    // PageView carousel
                                    PageView.builder(
                                      controller: _carouselController,
                                      itemCount: widget
                                          .project.carouselImagePaths.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.asset(
                                              widget.project
                                                  .carouselImagePaths[index],
                                              width: double.infinity,
                                              height: 220,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                                    // Page indicator
                                    if (widget
                                            .project.carouselImagePaths.length >
                                        1)
                                      Positioned(
                                        bottom: 16,
                                        left: 0,
                                        right: 0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: List.generate(
                                            widget.project.carouselImagePaths
                                                .length,
                                            (index) => AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4),
                                              width: _currentPage == index
                                                  ? 20
                                                  : 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color: _currentPage == index
                                                    ? themeColor
                                                    : Colors.white
                                                        .withOpacity(0.7),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Project Stats
                            if (widget.project.stats != null) ...[
                              _buildSectionHeader(Icons.bar_chart_rounded,
                                  "Project Stats", themeColor),
                              const SizedBox(height: 12),
                              _buildStatsRow(widget.project.stats!, themeColor),
                              const SizedBox(height: 24),
                            ],

                            // Description
                            Text(
                              widget.project.details,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                height: 1.6,
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Tech Stack
                            if (widget.project.techStack != null &&
                                widget.project.techStack!.isNotEmpty) ...[
                              _buildSectionHeader(
                                  Icons.code_rounded, "Tech Stack", themeColor),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: widget.project.techStack!
                                    .map(
                                      (tech) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                            color: Colors.grey.shade200,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          tech,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade800,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 32),
                            ],

                            // Key Features
                            if (widget.project.keyFeatures != null &&
                                widget.project.keyFeatures!.isNotEmpty) ...[
                              _buildSectionHeader(Icons.star_outline_rounded,
                                  "Key Features", themeColor),
                              const SizedBox(height: 16),
                              ...widget.project.keyFeatures!.map((feature) =>
                                  _buildFeatureItem(feature, themeColor)),
                              const SizedBox(height: 32),
                            ],

                            // Team Members
                            if (widget.project.teamMembers != null &&
                                widget.project.teamMembers!.isNotEmpty) ...[
                              _buildSectionHeader(
                                  Icons.groups_rounded, "Team", themeColor),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 140,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: widget.project.teamMembers!.length,
                                  itemBuilder: (context, index) {
                                    final member =
                                        widget.project.teamMembers![index];
                                    return _buildTeamMemberCard(
                                        member, themeColor);
                                  },
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],

                            // "Show More" / "Show Less" toggle for additional details
                            if (_hasExpandableContent(widget.project)) ...[
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showMoreDetails = !_showMoreDetails;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: themeColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _showMoreDetails
                                            ? "Show Less"
                                            : "Show More Details",
                                        style: TextStyle(
                                          color: themeColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        _showMoreDetails
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        color: themeColor,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Expandable content
                            if (_showMoreDetails) ...[
                              // Challenges
                              if (widget.project.challenges != null &&
                                  widget.project.challenges!.isNotEmpty) ...[
                                _buildSectionHeader(Icons.engineering_rounded,
                                    "Challenges & Solutions", themeColor),
                                const SizedBox(height: 16),
                                ...widget.project.challenges!.map((challenge) =>
                                    _buildChallengeItem(challenge, themeColor)),
                                const SizedBox(height: 32),
                              ],

                              // Future Enhancements
                              if (widget.project.futureEnhancements != null &&
                                  widget.project.futureEnhancements!
                                      .isNotEmpty) ...[
                                _buildSectionHeader(Icons.update_rounded,
                                    "Future Enhancements", themeColor),
                                const SizedBox(height: 16),
                                ...widget.project.futureEnhancements!.map(
                                    (enhancement) => _buildEnhancementItem(
                                        enhancement, themeColor)),
                                const SizedBox(height: 32),
                              ],

                              // Testimonials
                              if (widget.project.testimonials != null &&
                                  widget.project.testimonials!.isNotEmpty) ...[
                                _buildSectionHeader(Icons.format_quote_rounded,
                                    "Testimonials", themeColor),
                                const SizedBox(height: 16),
                                ...widget.project.testimonials!.map(
                                    (testimonial) => _buildTestimonialItem(
                                        testimonial, themeColor)),
                                const SizedBox(height: 32),
                              ],
                            ],

                            // Tags
                            if (widget.project.tags != null &&
                                widget.project.tags!.isNotEmpty) ...[
                              _buildSectionHeader(
                                  Icons.tag_rounded, "Tags", themeColor),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: widget.project.tags!
                                    .map(
                                      (tag) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: themeColor.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          "#$tag",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: themeColor,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 32),
                            ],

                            // Links section with buttons
                            _buildLinksSection(themeColor),

                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, Color themeColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: themeColor,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color themeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: themeColor,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: themeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(ProjectStats stats, Color themeColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (stats.users != null)
          _buildStatItem(Icons.people_alt_outlined,
              "${_formatNumber(stats.users!)} Users", themeColor),
        if (stats.stars != null)
          _buildStatItem(Icons.star_outline_rounded,
              "${_formatNumber(stats.stars!)} Stars", themeColor),
        if (stats.forks != null)
          _buildStatItem(Icons.fork_right_outlined,
              "${_formatNumber(stats.forks!)} Forks", themeColor),
        if (stats.downloads != null)
          _buildStatItem(Icons.download_outlined,
              "${_formatNumber(stats.downloads!)} DL", themeColor),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return "${(number / 1000000).toStringAsFixed(1)}M";
    } else if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(1)}K";
    }
    return number.toString();
  }

  Widget _buildStatItem(IconData icon, String text, Color themeColor) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: themeColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 22,
            color: themeColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(Feature feature, Color themeColor) {
    IconData iconData = Icons.check_circle_outline;
    if (feature.iconName != null) {
      // This would need a mapping of string names to IconData
      // For simplicity, we're just using a placeholder here
      iconData = _getIconFromName(feature.iconName!);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              iconData,
              size: 18,
              color: themeColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMemberCard(TeamMember member, Color themeColor) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade200,
              image: member.avatarPath != null
                  ? DecorationImage(
                      image: AssetImage(member.avatarPath!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: member.avatarPath == null
                ? Center(
                    child: Text(
                      member.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            _getLastName(member.name),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          if (member.role != null) ...[
            const SizedBox(height: 2),
            Text(
              member.role!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChallengeItem(Challenge challenge, Color themeColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 18,
                color: themeColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  challenge.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            challenge.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
              height: 1.4,
            ),
          ),
          if (challenge.solution != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: themeColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Solution",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: themeColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    challenge.solution!,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEnhancementItem(Future enhancement, Color themeColor) {
    String statusText = enhancement.status ?? "Planned";
    Color statusColor = _getStatusColor(statusText, themeColor);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.upcoming_outlined,
                size: 18,
                color: themeColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  enhancement.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            enhancement.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status, Color defaultColor) {
    switch (status.toLowerCase()) {
      case 'in progress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'planned':
        return defaultColor;
      default:
        return defaultColor;
    }
  }

  Widget _buildTestimonialItem(Testimonial testimonial, Color themeColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.format_quote,
            size: 24,
            color: themeColor,
          ),
          const SizedBox(height: 8),
          Text(
            testimonial.quote,
            style: TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                  image: testimonial.avatarPath != null
                      ? DecorationImage(
                          image: AssetImage(testimonial.avatarPath!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: testimonial.avatarPath == null
                    ? Center(
                        child: Text(
                          testimonial.author.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: themeColor,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    testimonial.author,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  if (testimonial.role != null)
                    Text(
                      testimonial.role!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLinksSection(Color themeColor) {
    final List<Widget> linkButtons = [];

    // Main project link
    if (widget.project.link.isNotEmpty) {
      linkButtons.add(
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          child: ElevatedButton.icon(
            onPressed: () => _launchURL(widget.project.link),
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
    if (widget.project.githubLink != null) {
      linkButtons.add(
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          child: OutlinedButton.icon(
            onPressed: () => _launchURL(widget.project.githubLink!),
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
    if (widget.project.additionalLinks != null &&
        widget.project.additionalLinks!.isNotEmpty) {
      for (int i = 0; i < widget.project.additionalLinks!.length; i++) {
        final String link = widget.project.additionalLinks![i];
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
        _buildSectionHeader(Icons.link_rounded, "Links", themeColor),
        const SizedBox(height: 16),
        ...linkButtons,
      ],
    );
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

  IconData _getIconFromName(String iconName) {
    // Map string icon names to IconData
    // This is a simplified version - in a real app, you'd have a more comprehensive mapping
    switch (iconName.toLowerCase()) {
      case 'settings':
        return Icons.settings;
      case 'security':
        return Icons.security;
      case 'performance':
        return Icons.speed;
      case 'design':
        return Icons.design_services;
      case 'integration':
        return Icons.integration_instructions;
      case 'analytics':
        return Icons.analytics;
      case 'notification':
        return Icons.notifications;
      case 'sync':
        return Icons.sync;
      case 'cloud':
        return Icons.cloud;
      case 'mobile':
        return Icons.smartphone;
      case 'web':
        return Icons.web;
      case 'accessibility':
        return Icons.accessibility;
      case 'payment':
        return Icons.payment;
      case 'social':
        return Icons.share;
      default:
        return Icons.check_circle_outline;
    }
  }

  bool _hasExpandableContent(ProjectModel project) {
    return (project.challenges != null && project.challenges!.isNotEmpty) ||
        (project.futureEnhancements != null &&
            project.futureEnhancements!.isNotEmpty) ||
        (project.testimonials != null && project.testimonials!.isNotEmpty);
  }
}
