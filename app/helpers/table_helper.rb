module TableHelper

  def table_title title, columns, image=''
    content_tag :table, class: 'title' do
      content_tag :tr do 
        content_tag :th, class: 'title' do
          image_tag(image) + title  unless image.empty?
        end
      end
    end
  end

end