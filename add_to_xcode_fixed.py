import uuid
import re

# Read the project file
with open('Test12.xcodeproj/project.pbxproj', 'r') as f:
    content = f.read()

# Files to add - including ContentView and Test12App
files_to_add = [
    ('Test12App.swift', 'Test12App.swift'),
    ('ContentView.swift', 'ContentView.swift'),
    ('User.swift', 'User.swift'),
    ('UserStore.swift', 'UserStore.swift'),
    ('StatCard.swift', 'StatCard.swift'),
    ('DashboardView.swift', 'DashboardView.swift'),
    ('MainTabView.swift', 'MainTabView.swift'),
    ('HomeView.swift', 'HomeView.swift'),
    ('ExploreView.swift', 'ExploreView.swift'),
    ('ProfileView.swift', 'ProfileView.swift'),
    ('SettingsView.swift', 'SettingsView.swift'),
    ('TodoListView.swift', 'TodoListView.swift'),
    ('TodoItem.swift', 'TodoItem.swift'),
    ('TodoStore.swift', 'TodoStore.swift'),
]

build_files = []
file_refs = []
group_children = []
source_files = []

for filename, path in files_to_add:
    # Generate UUIDs
    file_ref_uuid = uuid.uuid4().hex[:24].upper()
    build_file_uuid = uuid.uuid4().hex[:24].upper()
    
    # Create entries
    build_files.append(f"\t\t{build_file_uuid} /* {filename} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_uuid} /* {filename} */; }};")
    file_refs.append(f"\t\t{file_ref_uuid} /* {filename} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = \"{path}\"; sourceTree = \"<group>\"; }};")
    group_children.append(f"\t\t\t\t{file_ref_uuid} /* {filename} */,")
    source_files.append(f"\t\t\t\t{build_file_uuid} /* {filename} in Sources */,")

# Replace sections
new_build_files = "\n".join(build_files)
new_file_refs = "\n".join(file_refs)
new_group_children = "\n".join(group_children)
new_source_files = "\n".join(source_files)

# Insert into content
content = re.sub(
    r'(/\* Begin PBXBuildFile section \*/\n).*?(\n/\* End PBXBuildFile section \*/)',
    rf'\1{new_build_files}\2',
    content,
    flags=re.DOTALL
)

content = re.sub(
    r'(/\* Begin PBXFileReference section \*/\n).*?(\n/\* End PBXFileReference section \*/)',
    rf'\1{new_file_refs}\2',
    content,
    flags=re.DOTALL
)

content = re.sub(
    r'(F1C41758CE68463E8CB18870 /\* Test12 \*/ = \{\s+isa = PBXGroup;\s+children = \().*?(\n\t\t\t\);)',
    rf'\1\n{new_group_children}\2',
    content,
    flags=re.DOTALL
)

content = re.sub(
    r'(3EA678BEFCB54B688ADE0265 /\* Sources \*/ = \{\s+isa = PBXSourcesBuildPhase;\s+buildActionMask = 2147483647;\s+files = \().*?(\n\t\t\t\);)',
    rf'\1\n{new_source_files}\2',
    content,
    flags=re.DOTALL
)

# Write back
with open('Test12.xcodeproj/project.pbxproj', 'w') as f:
    f.write(content)

print("Files added to Xcode project successfully")
