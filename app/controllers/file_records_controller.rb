class FileRecordsController < ApplicationController
  include ActiveStorage::FileServer

  # GET /file_records/1 or /file_records/1.json
  def show
    file_record = FileRecord.find_by_uid(params[:id]).first!
    blob = file_record.data.attachment.blob
    serve_file named_disk_service(blob.service_name).path_for(blob.key), content_type: blob.content_type, disposition: "inline"
  end

  # POST /file_records
  def create
    file = params[:file]
    raise "lack file" if file.blank?
    @file_record = FileRecord.new(
      name: file.original_filename, type: file.content_type, data: file
    )
    if @file_record.save
      render json: @file_record, status: :created, location: @file_record
    else
      render json: @file_record.errors, status: :unprocessable_entity
    end
  end

  private
    def named_disk_service(name)
      ActiveStorage::Blob.services.fetch(name) do
        ActiveStorage::Blob.service
      end
    end
end
