module ApplicationHelper
    def full_title(page_title = "")
        if page_title != ""
            return "#{page_title} | 掲示板アプリ"
        else
            return "掲示板アプリ"
        end
    end
end
