import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About This Project'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).primaryColorLight.withOpacity(0.2),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Restaurant Reservation System App',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                'Version 1.0.0',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 20),
              Text(
                'This application is designed to provide a seamless and efficient way for restaurants to manage their reservations, customers, and tables. It features a robust backend API (built with Laravel) and a user-friendly Flutter frontend, ensuring a smooth experience for both restaurant staff and customers.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 30),
              Text(
                'Our Team',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark,
                    ),
              ),
              const SizedBox(height: 15),
              _buildTeamMemberCard(
                context,
                name: 'Leavchum Sopanha',
                role: 'Developer',
                description: 'Responsible for the database design and API development.',
                imageAsset: 'assets/images/panha.jpg',
              ),
              const SizedBox(height: 15),
              _buildTeamMemberCard(
                context,
                name: 'Ly Simouy',
                role: 'Developer',
                description: 'Focused on building customers management module.',
                imageAsset: 'assets/images/simouy.jpg',
              ),
              const SizedBox(height: 15),
              _buildTeamMemberCard(
                context,
                name: 'Phalla Chanheang',
                role: 'Developer',
                description: 'Focused on building tables management module.',
                imageAsset: 'assets/images/chanheang.jpg',
              ),
              const SizedBox(height: 15),
              _buildTeamMemberCard(
                context,
                name: 'Pouch Dalin',
                role: 'Developer',
                description:
                    'Focused on building reservations management module.',
                imageAsset: 'assets/images/dalin.jpg',
              ),
              const SizedBox(height: 30),
              Text(
                'Technologies Used',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark,
                    ),
              ),
              const SizedBox(height: 10),
              _buildTechnologyChip(context, 'Flutter (Frontend)'),
              _buildTechnologyChip(context, 'Laravel (Backend API)'),
              _buildTechnologyChip(context, 'Dart'),
              _buildTechnologyChip(context, 'PHP'),
              _buildTechnologyChip(context, 'MySQL/MariaDB'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMemberCard(
    BuildContext context, {
    required String name,
    required String role,
    required String description,
    required String imageAsset,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imageAsset),
              backgroundColor: Theme.of(context).primaryColorLight,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorDark,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnologyChip(BuildContext context, String tech) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Chip(
        label: Text(
          tech,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 3,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
