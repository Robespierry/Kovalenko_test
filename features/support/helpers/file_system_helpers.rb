# frozen_string_literal: true

def check_directory_exists(folder_name)
  raise 'Папка не существует' unless Dir.exist?($working_directory + folder_name)
end

def directory_has_downloading_files(path)
  Dir.foreach("#{$working_directory + path}\\").any? { |fname| File.extname(fname) == '.crdownload' }
end

def check_file_exists(folder_name:, file_name:)
  check_directory_exists(folder_name)

  $logger.info("Проверяю наличие файла #{$working_directory}#{folder_name}\\#{file_name}")
  File.exist?("#{$working_directory}#{folder_name}\\#{file_name}")
end

def delete_all_files_in_directory(dir_path)
  Dir.foreach($working_directory + dir_path) do |f|
    fn = File.join($working_directory + dir_path, f)
    File.delete(fn) if f != '.' && f != '..'
  end
end
