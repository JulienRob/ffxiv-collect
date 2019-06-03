module CollectionsHelper
  def sprite(collectable, model)
    id = model == 'achievement' ? collectable.icon_id : collectable.id
    image_tag('blank.png', class: "#{model} #{model}-#{id}")
  end

  def character_selected?
    @character.present?
  end

  def category_row_classes(collectable, active_category, ids = [])
    hidden = active_category.present? && collectable.category_id != active_category
    owned = ids.include?(collectable.id)
    "collectable category-row category-#{collectable.category_id}#{' hidden' if hidden }#{' owned' if owned}"
  end

  def td_owned(ids, collectable, manual = true, date = nil)
    owned = ids.include?(collectable.id)
    if manual && @character.verified_user?(current_user)
      content_tag(:td, class: 'text-center', data: { value: owned ? 1 : 0 }) do
        check_box_tag(nil, nil, owned, class: 'own',
                      data: { path: polymorphic_path(collectable, action: owned ? :remove : :add) })
      end
    else
      if owned
        if date.present?
          content_tag(:td, fa_icon('check'), class: 'text-center', data: { value: date.to_i, toggle: 'tooltip' },
                      title: "Achieved on #{format_date_short(date)}")
        else
          content_tag(:td, fa_icon('check'), class: 'text-center', data: { value: 1 })
        end
      else
        content_tag(:td, fa_icon('times'), class: 'text-center', data: { value: 0 })
      end
    end
  end

  def sources(collectable, list: false)
    sources = collectable.sources.map do |source|
      case(source.type.name)
      when 'Mog Station' then 'Mog Station'
      when 'Achievement' then "Achievement: #{source.text}"
      when 'Feast' then "The Feast: #{source.text}"
      else source.text
      end
    end

    if list && sources.size > 1
      content_tag(:ul, class: 'list-unstyled mb-0') do
        sources.each do |source|
          concat content_tag(:li, "\u2022 #{source}")
        end
      end
    else
      sources.join('<br>').html_safe
    end
  end
end
