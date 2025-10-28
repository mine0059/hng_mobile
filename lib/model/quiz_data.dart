import 'package:flutter/material.dart';
import 'package:hng_mobile/model/question.dart';
import 'package:hng_mobile/model/quiz_category.dart';

class QuizData {
  static final List<QuizCategory> categories = [
    QuizCategory(
      name: 'Technology',
      icon: Icons.computer,
      color: const Color(0xFF6C63FF),
      description:
          'Explore the power of technology and how it\'s shaping humanity.',
      questionCount: 10,
      questions: [
        Question(
          text: 'What does API stand for in software development?',
          options: [
            'Application Programming Interface',
            'Advanced Program Integration',
            'Automated Process Instruction',
            'Application Process Integration'
          ],
          correctAnswer: 0,
        ),
        Question(
          text:
              'Which programming language is known as the backbone of web development?',
          options: ['Python', 'JavaScript', 'C++', 'Ruby'],
          correctAnswer: 1,
        ),
        Question(
          text: 'What does CPU stand for?',
          options: [
            'Central Processing Unit',
            'Computer Personal Unit',
            'Central Program Utility',
            'Central Processor Upgrade'
          ],
          correctAnswer: 0,
        ),
        Question(
          text: 'Which company developed the Android operating system?',
          options: ['Apple', 'Microsoft', 'Google', 'Samsung'],
          correctAnswer: 2,
        ),
        Question(
          text: 'What is the purpose of version control systems like Git?',
          options: [
            'To control software versions',
            'Track changes and collaborate on code',
            'Speed up compilation',
            'Debug programs'
          ],
          correctAnswer: 1,
        ),
        Question(
          text: 'Which of these is NOT a database management system?',
          options: ['MySQL', 'MongoDB', 'PostgreSQL', 'JavaScript'],
          correctAnswer: 3,
        ),
        Question(
          text: 'What does HTML stand for?',
          options: [
            'Hyper Text Markup Language',
            'High Tech Modern Language',
            'Hyper Transfer Markup Logic',
            'Home Tool Markup Language'
          ],
          correctAnswer: 0,
        ),
        Question(
          text: 'Which cloud computing platform is owned by Amazon?',
          options: ['Azure', 'Google Cloud', 'AWS', 'IBM Cloud'],
          correctAnswer: 2,
        ),
        Question(
          text: 'What is machine learning primarily used for?',
          options: [
            'Building physical machines',
            'Teaching computers to learn from data',
            'Creating computer hardware',
            'Designing user interfaces'
          ],
          correctAnswer: 1,
        ),
        Question(
          text:
              'Which protocol is used for secure communication over the internet?',
          options: ['HTTP', 'FTP', 'HTTPS', 'SMTP'],
          correctAnswer: 2,
        ),
      ],
    ),
    QuizCategory(
      name: 'General Knowledge',
      icon: Icons.lightbulb_outline,
      color: const Color(0xFF6C63FF),
      description: 'Test your general knowledge with variety of questions.',
      questionCount: 10,
      questions: [
        Question(
          text: 'What is the capital of France?',
          options: ['Berlin', 'Madrid', 'Paris', 'Rome'],
          correctAnswer: 2,
        ),
        Question(
          text: 'Who painted the Mona Lisa?',
          options: [
            'Vincent van Gogh',
            'Leonardo da Vinci',
            'Pablo Picasso',
            'Michelangelo'
          ],
          correctAnswer: 1,
        ),
        Question(
          text: 'What is the largest ocean on Earth?',
          options: [
            'Atlantic Ocean',
            'Indian Ocean',
            'Arctic Ocean',
            'Pacific Ocean'
          ],
          correctAnswer: 3,
        ),
        Question(
          text: 'How many continents are there?',
          options: ['5', '6', '7', '8'],
          correctAnswer: 2,
        ),
        Question(
          text: 'What is the smallest country in the world?',
          options: ['Monaco', 'Vatican City', 'San Marino', 'Liechtenstein'],
          correctAnswer: 1,
        ),
        Question(
          text: 'Which planet is known as the Red Planet?',
          options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
          correctAnswer: 1,
        ),
        Question(
          text: 'Who wrote "Romeo and Juliet"?',
          options: [
            'Charles Dickens',
            'William Shakespeare',
            'Jane Austen',
            'Mark Twain'
          ],
          correctAnswer: 1,
        ),
        Question(
          text: 'What is the currency of Japan?',
          options: ['Yuan', 'Won', 'Yen', 'Rupee'],
          correctAnswer: 2,
        ),
        Question(
          text: 'How many days are in a leap year?',
          options: ['365', '366', '364', '367'],
          correctAnswer: 1,
        ),
        Question(
          text: 'What is the tallest mountain in the world?',
          options: ['K2', 'Kilimanjaro', 'Mount Everest', 'Denali'],
          correctAnswer: 2,
        ),
      ],
    ),
    QuizCategory(
      name: 'Science',
      icon: Icons.science,
      color: const Color(0xFF00C853),
      description:
          'Explore the wonders of science with questions on Physics, Chemistry, and Biology.',
      questionCount: 10,
      questions: [
        Question(
          text: 'What is the chemical symbol for water?',
          options: ['H2O', 'CO2', 'O2', 'NaCl'],
          correctAnswer: 0,
        ),
        Question(
          text: 'What is the speed of light?',
          options: [
            '300,000 km/s',
            '150,000 km/s',
            '450,000 km/s',
            '200,000 km/s'
          ],
          correctAnswer: 0,
        ),
        Question(
          text: 'What is the powerhouse of the cell?',
          options: ['Nucleus', 'Mitochondria', 'Ribosome', 'Chloroplast'],
          correctAnswer: 1,
        ),
        Question(
          text: 'Which gas do plants absorb from the atmosphere?',
          options: ['Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Hydrogen'],
          correctAnswer: 2,
        ),
        Question(
          text: 'What is the hardest natural substance on Earth?',
          options: ['Gold', 'Iron', 'Diamond', 'Platinum'],
          correctAnswer: 2,
        ),
        Question(
          text: 'What is the atomic number of Carbon?',
          options: ['6', '12', '8', '14'],
          correctAnswer: 0,
        ),
        Question(
          text: 'What force keeps planets in orbit around the Sun?',
          options: ['Magnetism', 'Gravity', 'Friction', 'Inertia'],
          correctAnswer: 1,
        ),
        Question(
          text: 'What is the most abundant gas in Earth\'s atmosphere?',
          options: ['Oxygen', 'Carbon Dioxide', 'Nitrogen', 'Hydrogen'],
          correctAnswer: 2,
        ),
        Question(
          text: 'How many bones are in the adult human body?',
          options: ['206', '208', '210', '204'],
          correctAnswer: 0,
        ),
        Question(
          text: 'What is the boiling point of water at sea level?',
          options: ['90°C', '100°C', '110°C', '120°C'],
          correctAnswer: 1,
        ),
      ],
    ),
    QuizCategory(
      name: 'History',
      icon: Icons.history,
      color: const Color(0xFFFF6F00),
      description: 'Test your knowledge of historical events and figures.',
      questionCount: 10,
      questions: [
        Question(
          text: 'In which year did World War II end?',
          options: ['1943', '1944', '1945', '1946'],
          correctAnswer: 2,
        ),
        Question(
          text: 'Who was the first President of the United States?',
          options: [
            'Thomas Jefferson',
            'George Washington',
            'Abraham Lincoln',
            'John Adams'
          ],
          correctAnswer: 1,
        ),
        Question(
          text: 'What year did the Titanic sink?',
          options: ['1910', '1912', '1914', '1916'],
          correctAnswer: 1,
        ),
        Question(
          text: 'Who was the first man on the moon?',
          options: [
            'Buzz Aldrin',
            'Neil Armstrong',
            'Yuri Gagarin',
            'Michael Collins'
          ],
          correctAnswer: 1,
        ),
        Question(
          text: 'Which empire built Machu Picchu?',
          options: ['Aztec', 'Maya', 'Inca', 'Olmec'],
          correctAnswer: 2,
        ),
        Question(
          text: 'When did the Berlin Wall fall?',
          options: ['1987', '1989', '1991', '1993'],
          correctAnswer: 1,
        ),
        Question(
          text: 'Who discovered America in 1492?',
          options: [
            'Christopher Columbus',
            'Amerigo Vespucci',
            'Ferdinand Magellan',
            'Vasco da Gama'
          ],
          correctAnswer: 0,
        ),
        Question(
          text:
              'What was the name of the ship that brought Pilgrims to America?',
          options: ['Santa Maria', 'Mayflower', 'Endeavour', 'Discovery'],
          correctAnswer: 1,
        ),
        Question(
          text: 'Who was known as the Iron Lady?',
          options: [
            'Angela Merkel',
            'Margaret Thatcher',
            'Indira Gandhi',
            'Golda Meir'
          ],
          correctAnswer: 1,
        ),
        Question(
          text: 'In which year did India gain independence?',
          options: ['1945', '1947', '1950', '1952'],
          correctAnswer: 1,
        ),
      ],
    ),
    QuizCategory(
      name: 'Geography',
      icon: Icons.map,
      color: const Color(0xFFFF6F00),
      description:
          'Test your knowledge of the world with questions about countries.',
      questionCount: 10,
      questions: [
        Question(
          text: 'What is the capital of Australia?',
          options: ['Sydney', 'Melbourne', 'Canberra', 'Brisbane'],
          correctAnswer: 2,
        ),
        Question(
          text: 'Which is the longest river in the world?',
          options: ['Amazon', 'Nile', 'Yangtze', 'Mississippi'],
          correctAnswer: 1,
        ),
        Question(
          text: 'What is the largest desert in the world?',
          options: ['Sahara', 'Arabian', 'Gobi', 'Antarctic Desert'],
          correctAnswer: 3,
        ),
        Question(
          text: 'Which country has the most natural lakes?',
          options: ['USA', 'Russia', 'Canada', 'Brazil'],
          correctAnswer: 2,
        ),
        Question(
          text: 'What is the smallest continent?',
          options: ['Europe', 'Australia', 'Antarctica', 'South America'],
          correctAnswer: 1,
        ),
        Question(
          text: 'Which African country is known as the "Pearl of Africa"?',
          options: ['Kenya', 'Tanzania', 'Uganda', 'Rwanda'],
          correctAnswer: 2,
        ),
        Question(
          text: 'What is the capital of Canada?',
          options: ['Toronto', 'Vancouver', 'Ottawa', 'Montreal'],
          correctAnswer: 2,
        ),
        Question(
          text: 'Which country is home to the Amazon Rainforest?',
          options: ['Peru', 'Colombia', 'Brazil', 'Venezuela'],
          correctAnswer: 2,
        ),
        Question(
          text: 'What is the currency of the United Kingdom?',
          options: ['Euro', 'Dollar', 'Pound Sterling', 'Franc'],
          correctAnswer: 2,
        ),
        Question(
          text: 'Which ocean is the smallest?',
          options: [
            'Indian Ocean',
            'Arctic Ocean',
            'Southern Ocean',
            'Atlantic Ocean'
          ],
          correctAnswer: 1,
        ),
      ],
    ),
  ];

  // Get default category (Technology)
  static QuizCategory get defaultCategory => categories[0];
}
