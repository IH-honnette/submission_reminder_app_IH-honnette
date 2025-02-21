#!/bin/bash

# validate input (only letters and underscores)
validate_name() {
    if [[ ! "$1" =~ ^[a-zA-Z_]+$ ]]; then
        return 1
    fi
    return 0
}

get_valid_name() {
    local valid_name=false
    local name=""
    
    while [ "$valid_name" = false ]; do
        read -r name
        
        if validate_name "$name"; then
            valid_name=true
        else
            echo "Error: Name can only contain letters and underscores (e.g., Honest_Do)."
            echo "Please enter your name (use only letters and underscores): "
        fi
    done
    
    echo "$name"
}

clear
echo "========================================"
echo "|     SET_UP SUBMISSION REMINDER APP   |" 
echo "========================================"
echo "Enter name to set up the environment: "
name=$(get_valid_name)

# Create main directory with student's name
main_dir="submission_reminder_${name}"
echo "Creating directory structure for ${main_dir}..."

# Create directory structure
mkdir -p "${main_dir}"/{app,modules,assets,config}

# Create config.env 
cat > "${main_dir}/config/config.env" << EOF
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# Create reminder.sh file
cat > "${main_dir}/app/reminder.sh" << 'EOF'
#!/bin/bash

# Source environment variables and helper functions
source ../config/config.env
source ../modules/functions.sh

# Path to the submissions file
submissions_file="../assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions "$submissions_file"
EOF

# Create functions.sh file 
cat > "${main_dir}/modules/functions.sh" << 'EOF'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

# Create submissions.txt with header and initial students
cat > "${main_dir}/assets/submissions.txt" << 'EOF'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
EOF

# Set proper permissions
chmod +x "${main_dir}/app/reminder.sh"
chmod +x "${main_dir}/modules/functions.sh"

# Defined list of courses in the system
courses=("Shell Navigation" "Shell Basics" "Git")
echo "Commonly used courses in this system: ${courses[*]}"

# Function to validate submission status
validate_status() {
    local status=$1
    if [[ "$status" == "submitted" || "$status" == "not submitted" ]]; then
        return 0
    else
        return 1
    fi
}

# Function to add random students
add_random_students() {
    local count=$1
    local submissions_file=$2
    
    # names pool for randomization
    first_names=("Michael" "Sarah" "David" "Jenny" "Daniel" "Emily" "James" "Oliva" "William" "Ihozo" 
                "Alexia" "Siri" "Tom" "Ava" "Robert" "Charlotte" "John" "Amelia" "Joseph" "Mia")
    
    for ((i=1; i<=$count; i++)); do
        # Generate a random student
        random_name=${first_names[$RANDOM % ${#first_names[@]}]}
        random_course=${courses[$RANDOM % ${#courses[@]}]}
        
        if [ $(($RANDOM % 10)) -lt 7 ]; then
            status="not submitted"
        else
            status="submitted"
        fi
        
        # Add student to file
        echo "$random_name, $random_course, $status" >> "$submissions_file"
    done
    
    echo "Added $count randomly generated students to the submissions list."
}

# Function to manually add a student
add_manual_student() {
    local submissions_file=$1
    local student_name=""
    local course=""
    local status=""
    local valid_course=false
    local valid_status=false
    
    # Get student name
    echo -n "student name: "
    read student_name
    
    # Get course selection
    echo "Select a course:"
    for i in "${!courses[@]}"; do
        echo "$(($i+1)). ${courses[$i]}"
    done
    
    while [ "$valid_course" = false ]; do
        echo -n "Enter course number (1-${#courses[@]}): "
        read course_num
        
        if [[ "$course_num" =~ ^[0-9]+$ ]] && [ "$course_num" -ge 1 ] && [ "$course_num" -le "${#courses[@]}" ]; then
            course="${courses[$(($course_num-1))]}"
            valid_course=true
        else
            echo "Invalid selection. Please enter a number between 1 and ${#courses[@]}."
        fi
    done
    
    # Get submission status
    while [ "$valid_status" = false ]; do
        echo -n "Enter submission status (submitted/not submitted): "
        read status
        
        if validate_status "$status"; then
            valid_status=true
        else
            echo "Invalid status. Please enter either 'submitted' or 'not submitted'."
        fi
    done
    
    # Add student to file
    echo "$student_name, $course, $status" >> "$submissions_file"
   # echo "Added student: $student_name, $course, $status"
}

# randomly generate or manually add students
echo -e "\nYou need to add 5 more students to the submissions list."
echo "How would you like to add them?"
echo "1. Randomly generate 5 students"
echo "2. Manually enter 5 students"
read -p "Enter your choice (1/2): " add_choice

if [ "$add_choice" = "1" ]; then
    # Add 5 random students
    add_random_students 5 "$main_dir/assets/submissions.txt"
else
    # Manually add 5 students
    echo "You will now enter details for 5 students."
    for i in {1..5}; do
        echo -e "\nStudent $i of 5:"
        add_manual_student "$main_dir/assets/submissions.txt"
    done
fi

# Create startup.sh file
cat > $main_dir/startup.sh << 'EOF'
#!/bin/bash

# Submission Reminder Application Startup Script

clear
echo "========================================"
echo " ASSIGNMENT SUBMISSION REMINDER SYSTEM  "
echo "========================================"
echo

# Check for required directories and files
if [ ! -d "app" ] || [ ! -d "modules" ] || [ ! -d "assets" ] || [ ! -d "config" ]; then
    echo "Error: Missing required directories. Make sure you're in the main application directory."
    exit 1
fi

if [ ! -f "app/reminder.sh" ] || [ ! -f "modules/functions.sh" ] || [ ! -f "assets/submissions.txt" ] || [ ! -f "config/config.env" ]; then
    echo "Error: Missing required files. Please check your installation."
    exit 1
fi

# Make dependent scripts executable
chmod +x app/reminder.sh
chmod +x modules/functions.sh

# Load configuration
source config/config.env

echo "Today's date: $(date '+%Y-%m-%d')"
echo

# Count submissions to check
total_submissions=$(wc -l < assets/submissions.txt)
total_submissions=$((total_submissions - 1))  # Subtract header line
echo "Total student records to check: $total_submissions"
echo

# Run the reminder script
echo "Starting reminder process..."
echo "------------------------------"
cd app && ./reminder.sh
echo "------------------------------"
echo
echo "Reminder process completed successfully."
echo "========================================"
EOF
chmod +x $main_dir/startup.sh

# Display total number of students in the file
total_students=$(wc -l < "$main_dir/assets/submissions.txt")
total_students=$((total_students - 1))  # Subtract header line

echo -e "\nEnvironment setup complete! Directory structure created at $main_dir"
echo "Total number of students in submissions.txt: $total_students"
echo ""
echo "To run the application:"
echo "1. cd $main_dir"
echo "2. ./startup.sh"