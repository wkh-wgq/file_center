class FileRecordsController < ApplicationController

  before_action do
    ActiveStorage::Current.url_options = { protocol: 'https', host: request.host }
  end
  # include ActiveStorage::SetCurrent

  # GET /file_records/1 or /file_records/1.json
  def show
    file_record = FileRecord.find_by_uid(params[:id]).first!
    blob = file_record.data.attachment.blob
    # 这里不知道为什么重定向的请求 http://172.16.100.22:4000/rails/active_storage/...会变为
    #                         https://172.16.100.22/rails/active_storage/...
    # 导致识别不出来，所以手动改为 https://172.16.100.22/file_center_api/rails/active_storage/...
    url = blob.url.gsub('/rails/', '/file_center_api/rails/')
    redirect_to url, allow_other_host: true
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
end
