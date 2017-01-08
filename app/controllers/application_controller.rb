require 'mp3info'
require 'fileutils'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
  	@files = Dir["/d/DJ/To Review/**/*.mp3"]

  	begin
  	@index = rand(@files.length)
	  @file = @files[@index]
	  logger.debug "File: #{@file}"
		@file_info = Mp3Info.open(@file).tag
  	logger.debug(@file_info)
		@title = @file_info.title
		@artist = @file_info.artist
		@album = @file_info.album
		@filename = @file.split("/").last
		@new_filename = "#{@artist} - #{@title}.mp3"
	rescue Mp3InfoError => e
	  logger.debug "\n\n\n\n********************** BROKEN! #{e}"
	  logger.debug "Moving to /d/DJ/To Review (broken)"
	  FileUtils.mv(@file, "/d/DJ/To Review (broken)/")
	  @file = nil
  	end while @file.nil?
  end

  def stream
  	@files = Dir["/d/DJ/To Review/**/*.mp3"]
  	logger.debug(params)
  	@filename = @files[params[:index].to_i]
  	render :text => "No file found" unless File.exists?(@filename)
  	send_file @filename, :type => "audio/mpeg"
  end

  def nogood
  	@files = Dir["/d/DJ/To Review/**/*.mp3"]
  	logger.debug(params)
  	@filename = @files[params[:index].to_i]
  	logger.debug("Moving #{@filename} to delete folder")
	  FileUtils.mv(@filename, "/d/DJ/To Review (delete)/")
		redirect_to :action => :index  	
  end

  def rename
  	@files = Dir["/d/DJ/To Review/**/*.mp3"]
  	logger.debug(params)
  	@filename = @files[params[:index].to_i]
		@file_info = Mp3Info.open(@filename).tag
  	logger.debug(@file_info)
		@title = @file_info.title
		@artist = @file_info.artist
		@album = @file_info.album
		@new_filename = "#{@artist} - #{@title}.mp3"
  	logger.debug("Moving #{@filename} to delete folder")
	  FileUtils.mv(@filename, "/d/DJ/Incoming/Booth/#{@new_filename}")
		redirect_to :action => :index  	
  end

  def keepname
  	@files = Dir["/d/DJ/To Review/**/*.mp3"]
  	logger.debug(params)
  	@filename = @files[params[:index].to_i]
  	logger.debug("Moving #{@filename} to delete folder")
	  FileUtils.mv(@filename, "/d/DJ/Incoming/Booth/")
		redirect_to :action => :index  	
  end

end
