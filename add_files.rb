require 'xcodeproj'

project_path = 'Test12.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Get the main target
target = project.targets.first

# Get the main group
main_group = project.main_group['Test12']

# Files to add
files_to_add = [
  'Test12/User.swift',
  'Test12/UserStore.swift',
  'Test12/StatCard.swift',
  'Test12/DashboardView.swift'
]

files_to_add.each do |file_path|
  # Check if file already exists in project
  existing_file = main_group.files.find { |f| f.path == File.basename(file_path) }
  
  unless existing_file
    # Add file reference to the group
    file_ref = main_group.new_file(file_path)
    
    # Add file to the build phase
    target.add_file_references([file_ref])
    
    puts "Added #{file_path}"
  else
    puts "#{file_path} already exists"
  end
end

project.save
puts "Project saved"
