# ------------------------------------------------------------------------------
# Check pull request data
# ------------------------------------------------------------------------------
#pr_number = github.pr_json["number"]
#pr_url = github.pr_json["_links"]["html"]["href"]

if github.pr_title.include?("WIP") || github.pr_labels.include?("DO NOT MERGE")
    warn("🚧 PR is classed as Work in Progress, this should not be merged.")
end
warn("🚧 Big PR") if git.lines_of_code > 500
warn("🚧 Please, provide a description to your PR") if github.pr_body.empty?
if git.modified_files.empty? && git.added_files.empty? && git.deleted_files.empty?
  fail "⚠️ This PR has no changes at all."
end

has_milestone = github.pr_json["milestone"] != nil
warn("⚠️ This MR does not refer to an existing milestone", sticky: true) unless has_milestone


# Local Configurations

view_extensions = ['.xib', '.storyboard', 'View.swift', 'Button.swift']
has_view_changes = git.modified_files.any? { |file| view_extensions.any? { |ext| file.end_with? ext }}
pr_has_screenshot = github.pr_body =~ /https?:\/\/\S*\.(png|jpg|jpeg|gif){1}/
warn("View files were changed. Maybe you want to add a screenshot to your PR.") if has_view_changes and !pr_has_screenshot


# ------------------------------------------------------------------------------
# Code check.
# ------------------------------------------------------------------------------

duplicate_localizable_strings.check_localizable_duplicates

# ------------------------------------------------------------------------------
# Git checks.
# ------------------------------------------------------------------------------

# Make sure the commit message is formatted properly
# Rules: https://github.com/jonallured/danger-commit_lint#usage
commit_lint.check warn: :all

# Prevent merging PRs with commits intended to be rebased
if git.commits.any? { |c| c.message.include?('fixup!') || c.message.include?('squash!') }
  fail('⚠️ This PR contains commits marked as squash or fixup. Please perform an interactive rebase to apply the changes.')
end

#check if the commit is not empty and is well formatted by respected the pattern of Meero (Angular repo style)
#first_branch_name_token = actual_branch_name.split("/").first
#last_branch_name_token = actual_branch_name.split("/").last
#expected_commit_name = first_branch_name_token + "(" + last_branch_name_token + ")" + ": "
#if git.commits.any? { |c| c.message =~ /#{Regexp.escape(expected_commit_name)}.+/ }
#    message "👨‍💻 The commit name respects the pattern category(description):[SPACE] short description ✅"
#else
#    fail "⚠️ The commit name must respect category(description):[SPACE] short description #{expected_commit_name} 💥 "
#end

# ------------------------------------------------------------------------------
# Cocoa pod changes.
# ------------------------------------------------------------------------------

podfile_updated = !git.modified_files.grep(/Podfile/).empty?
if podfile_updated
  warn "🚧 The podfile was updated, don't forget to execute a pod update"
end

# ------------------------------------------------------------------------------
# Swiftlint.
# ------------------------------------------------------------------------------
swiftlint.config_file = './app/.swiftlint.yml'
swiftlint.lint_all_files = true
swiftlint.verbose = true
swiftlint.lint_files inline_mode: true
# ------------------------------------------------------------------------------
# Slack.
# ------------------------------------------------------------------------------

#slack.notify(channel: '#notification')
message("👨‍💻 #{github.pr_author} Good job on cleaning the code ✅✅✅") if git.deletions > git.insertions
