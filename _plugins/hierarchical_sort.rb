# vim:set ts=8 sts=2 sw=2 tw=0 et:

module HierarchicalSort

  class Utils
    def Utils.keys(page)
      keys = page.to_liquid['url'].split('/')
      if keys.length > 0 and keys[0].length == 0
        keys.shift
      end
      return keys
    end

    def Utils.priority(p)
      return p.data.has_key?('sort_priority') ? p.data['sort_priority'] : -1
    end
  end

  class PriorityTable
    def initialize(pages)
      @table = {}
      pages.each { |p| add(p) }
      finish
    end

    private
    def add(page)
      @table[page.data['hierarchical_sort_keys'].join('/')] =
        Utils.priority(page)
    end

    private
    def finish()
      max = 0
      keys = []
      priorities = {}
      @table.each { |k, v|
        if v < 0
          keys.push(k)
          last = k.split('/')[-1]
          priorities[k] = last ? last : ''
        elsif v > max
          max = v
        end
      }
      keys.sort { |a, b|
        priorities[a] <=> priorities[b]
      }.each { |k|
        @table[k] = (max += 1)
      }
    end

    public
    def get(page)
      priorities = []
      curr = []
      page.data['hierarchical_sort_keys'].each { |k|
        key = curr.push(k).join('/')
        priorities.push(@table.has_key?(key) ? @table[key] : 0)
      }
      return priorities
    end
  end

  class PageItem

    attr_accessor :page, :priorities

    def initialize(page, table)
      @page = page
      @priorities = table.get(page)
      page.data['hierarchical_sort_priorities'] = @priorities
    end

    def <=>(obj)
      len1 = priorities.length
      len2 = obj.priorities.length
      min = [ len1, len2 ].min
      i = 0
      while i < min
        r = priorities[i] <=> obj.priorities[i]
        return r if r != 0
        i += 1
      end
      return len1 <=> len2
    end

  end

  class Sorter < Jekyll::Generator

    def initialize(config)
    end

    def generate(site)
      site.pages.each { |p|
        p.data['hierarchical_sort_keys'] = Utils.keys(p)
      }

      table = PriorityTable.new(site.pages)

      site.config['hierarchical_pages'] = site.pages.map { |p|
        PageItem.new(p, table)
      }.sort { |a, b|
        a <=> b
      }.map { |i|
        i.page
      }
    end

  end

end
