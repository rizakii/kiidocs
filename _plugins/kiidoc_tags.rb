module KiidocTags

  class ParentsTag < Liquid::Tag
    def initialize(tag_name, argv, tokens)
      super
    end

    def render(context)
      page = context['page']
      if not page.has_key?('parents')
        msg = "ERROR: page #{page['url']} doesn't have parents"
        puts msg
        return msg
      end
      out = []
      page['parents'].each { |p|
        out.push "<a href=\"#{p.data['cached_url']}\">#{p.data['title']}</a><span> &gt; </span>"
      }
      return out.join("\n")
    end
  end

  class TreeNavTag < Liquid::Tag
    def initialize(tag_name, argv, tokens)
      super
      @root = "/#{argv.strip}/"
    end

    def render(context)
      page = context['page']
      if not page.has_key?('hierarchical_pages')
        msg = "ERROR: page #{page['url']} doesn't have hierarchical_pages"
        puts msg
        return msg
      end

      current_rank = -1
      base_rank = -1

      out = []
      page['hierarchical_pages'].each { |p|
        url = p.data['cached_url']
        if not (url.include?(@root) and url != @root)
          next
        end

        rank = p.data['hierarchical_rank']
        title = p.data['title']

        if rank > current_rank
          if current_rank < 0
            base_rank = rank - 1
            out.push '<ul>'
          else
            out.push '<ul class="subpage">'
          end
          current_rank = rank
        elsif rank < current_rank
          for i in (rank + 1)..current_rank do
            out.push '</li>'
            out.push '</ul>'
          end
          current_rank = rank
        else
          out.push '</li>'
        end

        if page['url'] == url
          attr_class = ' class="selected"'
        elsif page['hierarchical_ancestors_url'].include?(url)
          attr_class = ' class="selected_parent"'
        else
          attr_class = ''
        end
        out.push "<li#{attr_class}><div><a href=\"#{url}\">#{title}</a></div>"
      }
      if current_rank > base_rank
        for i in (base_rank + 1)..current_rank do
          out.push '</li>'
          out.push '</ul>'
        end
      end
      return out.join("\n")
    end
  end

end

Liquid::Template.register_tag('kiidoc_parents', KiidocTags::ParentsTag)
Liquid::Template.register_tag('kiidoc_treenav', KiidocTags::TreeNavTag)

# vim:set ts=8 sts=2 sw=2 tw=0 et:
