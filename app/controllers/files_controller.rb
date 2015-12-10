class FilesController < ApplicationController

  def convert
    file = params[:input][:ged_file].tempfile.path
    @parser = FileParser.new(file)
    send_data @parser.to_xml, :type => 'text/xml; charset=UTF-8;', :disposition => "attachment; filename=output.xml"
  end

end
