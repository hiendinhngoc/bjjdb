module SearchHelper
  def display_search_parameters(result_count, params)
    # Add the below code to this
 ####     <% if @total_results > 0 %>
 ####       <h2 class="lead"><strong class="text-danger"><%= @total_results %></strong> results were found for the search for <%= display_search_parameters(params) %></h2>
 ####     <% else %>
 ####       <h2 class="lead">No results found for <strong class="text-danger"><%= params[:q] %></strong></h2>
 ####     <% end %>

    rv = '<h2 class="lead">' + pluralize(result_count, "result") + ' for '

    if params[:q]
      rv = rv + "<strong class='text-danger'>#{params[:q]}</strong>"
    end

    if params[:tag_ids].present? and params[:tag_ids].length > 0
      rv = rv + " tags: "
      Tag.where(id: params[:tag_ids]).each do |tag|
        rv = rv + link_to(tag.full_name, tag, class: 'tag')
      end
    end
    rv.html_safe
  end
end
