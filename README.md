# 📌 Assignment Submission Reminder System  

## 📝 Overview  

The **Assignment Submission Reminder System** is a Bash-based script that helps track student assignment submissions. It automatically checks for pending submissions and notifies students who haven't submitted their assignments.  

## 🔧 Features  

- ✅ Generates a structured directory for tracking submissions  
- ✅ Stores student submissions in a text file (`submissions.txt`)  
- ✅ Allows manual or random addition of students  
- ✅ Checks for pending submissions and print reminders  
- ✅ Ensures input validation for student names and statuses  
- ✅ Easy to run with a single command  

## 📂 Project Structure  

```bash
submission_reminder_<name>/
│── app/
│   ├── reminder.sh            # Main script to check pending submissions
│── modules/
│   ├── functions.sh           # Helper functions for processing submissions
│── assets/
│   ├── submissions.txt        # List of students and their submission status
│── config/
│   ├── config.env             # Configuration file (e.g., assignment name, deadlines)
│── startup.sh                 # Entry point to run the application

```
## 🚀 How to Run

1. Clone the repository:
   ```bash
   git clone https://github.com/IH-honnette/submission_reminder_app_IH-honnette.git
    ```
2. Navigate to the project directory:
    ```bash
    chmod +x create_environment.sh && ./create_environment.sh
    cd submission_reminder_<name>
    ```
3. Run the application:
    ```bash
    ./startup.sh
    ```
4. Follow the on-screen instructions to add students and check pending submissions.

## ⚙️ Customization 

1. To modify the assignment name or days remaining, edit the config/config.env file.

2. To manually add students, edit assets/submissions.txt following the format:

    ```plaintext
    Student Name, Course, Status
    John_Doe, Shell Navigation, not submitted
    ```
## 📌 Notes
1. Ensure you have Bash installed.

2. The script only accepts letters and underscores in names.

3. The application requires execution permissions (chmod +x script_name.sh).

