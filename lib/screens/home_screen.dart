import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hng_mobile/blocs/switch_bloc/switch_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Portfolio'),
        centerTitle: true,
        elevation: 0,
        actions: [
          BlocBuilder<SwitchBloc, SwitchState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  context.read<SwitchBloc>().add(SwitchToggleEvent());
                },
                icon: Icon(
                  state.switchValue ? Icons.dark_mode : Icons.light_mode,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                tooltip: state.switchValue
                    ? 'Switch to Dark Mode'
                    : 'Switch to Light Mode',
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            _buildHeaderSection(context),

            // About Section
            _buildAboutSection(context),

            // Skills Section
            _buildSkillsSection(context),

            // Contact Section
            _buildContactSection(context),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.05),
          ],
        ),
      ),
      child: Column(
        children: [
          // Profile Image
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 3,
              ),
              image: const DecorationImage(
                image: AssetImage('assets/images/mine.jpg'),
                fit: BoxFit.cover,
              ),
              // image: const DecorationImage(
              //   image: NetworkImage(
              //     'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80',
              //   ),
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Oghenemine Emmanuel',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Flutter Developer & Mobile Engineer',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Building beautiful cross-platform experiences',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Me',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'I\'m a passionate Flutter developer with over 2 years of experience building '
            'high-quality mobile applications. I specialize in creating beautiful, '
            'performant, and user-friendly apps that provide exceptional user experiences.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                  height: 1.6,
                ),
          ),
          const SizedBox(height: 20),
          _buildInfoRow(context, Icons.location_on, 'Enugu, Nigeria'),
          _buildInfoRow(context, Icons.work, 'Full-time Developer'),
          _buildInfoRow(context, Icons.school, 'B.Sc Biochemistry'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(BuildContext context) {
    final skills = [
      {'name': 'Flutter/Dart', 'level': 90.0},
      {'name': 'Firebase', 'level': 85.0},
      {'name': 'REST APIs', 'level': 80.0},
      {'name': 'State Management', 'level': 88.0},
      {'name': 'UI/UX Design', 'level': 75.0},
      {'name': 'Git & GitHub', 'level': 82.0},
    ];

    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skills & Technologies',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
          const SizedBox(height: 20),
          ...skills.map((skill) => _buildSkillItem(context, skill)),
        ],
      ),
    );
  }

  Widget _buildSkillItem(BuildContext context, Map<String, dynamic> skill) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skill['name'],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              Text(
                '${skill['level']}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.6),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: (skill['level'] as double) *
                    3.5, // Adjust based on your layout
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Get In Touch',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
          const SizedBox(height: 20),
          Text(
            'I\'m always open to discussing new opportunities, '
            'collaborative projects, or just having a chat about technology '
            'and mobile development.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                  height: 1.6,
                ),
          ),
          const SizedBox(height: 30),
          _buildContactButton(
            context,
            Icons.email,
            'Email',
            'onojefemuemine@gmail.com',
            () {
              // Handle email tap
            },
          ),
          _buildContactButton(
            context,
            Icons.phone,
            'Phone',
            '+234 916 478 0338',
            () {
              // Handle phone tap
            },
          ),
          _buildContactButton(
            context,
            Icons.link,
            'LinkedIn',
            'https://www.linkedin.com/in/oghenemine-onojefemue-913360339/',
            () {
              // Handle LinkedIn tap
            },
          ),
          _buildContactButton(
            context,
            Icons.code,
            'GitHub',
            'https://github.com/mine0059',
            () {
              // Handle GitHub tap
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: Theme.of(context).colorScheme.surface,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
              ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
        ),
        onTap: onTap,
      ),
    );
  }
}
