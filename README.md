# ES School Management System

A comprehensive school management system built with Ruby on Rails that helps manage students, teachers, classes, and grades. The system supports different user roles (Dean, Teacher, Student) with appropriate permissions and features for each role.

## Features

### For Deans
- Manage all aspects of the school system
- View and manage all students, teachers, and classes
- Create and manage quarters (academic periods)
- Add and edit grades for any student
- View comprehensive reports and statistics
- Manage class types and themes (subjects)
- Handle room assignments and scheduling

### For Teachers
- View their assigned classes and students
- Add and edit grades for their students
- View student performance and progress
- Access class schedules and room information
- Manage their own courses and themes

### For Students
- View their grades and academic progress
- Access their class schedule
- View their overall performance statistics
- Generate PDF reports of their grades

## Technical Features
- Role-based authentication with Devise
- Authorization with Pundit
- Role management with Rolify
- Soft deletion for archived records
- PDF generation with Prawn
- Responsive design with Bootstrap
- Interactive calendar view for schedules
- Grade tracking with averages and statistics
- Multi-quarter academic period management
- Hotwire (Turbo and Stimulus) for dynamic interactions
- Importmap for JavaScript management

## Prerequisites
- Ruby 3.2.2 or higher
- Rails 8.0.2
- SQLite3
- Node.js (for JavaScript dependencies)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/es-school.git
cd es-school
```

2. Install dependencies:
```bash
bundle install
```

3. Set up the database:
```bash
rails db:create
rails db:migrate
```

4. Seed the database with sample data:
```bash
rails db:seed
```

## Running the Application

1. Start the Rails server:
```bash
rails server
```

2. Visit `http://localhost:3000` in your browser

## Default User Credentials

### Deans
```
Email: dean1@example.com
Password: password
```

### Teachers
```
Email: teacher1@example.com
Password: password
```

### Students
```
Email: good_student1@example.com
Password: password
```

## Project Structure

```
es-school/
├── app/
│   ├── controllers/    # Application controllers
│   ├── models/        # Database models
│   ├── views/         # View templates
│   ├── policies/      # Authorization policies
│   └── helpers/       # View helpers
├── config/            # Application configuration
├── db/               # Database files and migrations
├── lib/              # Library modules
└── test/             # Test files
```

## Key Models

- **User**: Base user model with role-based authentication
- **Student**: Student-specific information and associations
- **Teacher**: Teacher-specific information and associations
- **Classroom**: Class information and scheduling
- **Course**: Individual courses within classrooms
- **Grade**: Student grades and performance tracking
- **Quarter**: Academic periods
- **Theme**: Subject/themes taught in courses
- **Room**: Physical classroom locations

## Key changes in the class diagram
Some names weren't open to be used, like modules and classes, which forced me to change their names to Themes and ClassRooms.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, please open an issue in the GitHub repository or contact the development team.
