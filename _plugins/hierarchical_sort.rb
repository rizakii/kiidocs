# vim:set ts=8 sts=2 sw=2 tw=0 et:

module HierarchicalSort

  class Utils
    def Utils.keys(url)
      keys = url.split('/')
      if keys.length > 0 and keys[0].length == 0
        keys.shift
      end
      return keys
    end

    def Utils.key(page)
      url = page.to_liquid['url']
      return Utils.keys(url).join('/')
    end

    def Utils.priority(p)
      return p.data.has_key?('sort_priority') ? p.data['sort_priority'] : -1
    end
  end

  class PriorityTable
    def initialize()
      @table = {}
    end

    def add(page)
      @table[Utils.key(page)] = Utils.priority(page)
    end

    def finish()
      max = 0
      keys = []
      priorities = {}
      @table.each { |k, v|
        if v < 0
          keys.push(k)
          s = k.split('/')[-1]
          priorities[k] = s ? s : ''
        elsif v > max
          max = v
        end
      }
      keys.sort! { |a, b| priorities[a] <=> priorities[b] }
      keys.each { |k| @table[k] = (max += 1) }
    end

    def get(page)
      url = page.to_liquid['url']
      priorities = []
      curr = []
      Utils.keys(url).each { |k|
        key = curr.push(k).join('/')
        priorities.push(@table.has_key?(key) ? @table[key] : 0)
      }
      return priorities
    end
  end

  class PageItem

    attr_accessor :page, :priorities

    def initialize(page, priorityTable)
      @page = page
      @priorities = priorityTable.get(page)
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
      priorities = PriorityTable.new()
      site.pages.each { |p| priorities.add(p) }
      priorities.finish
      site.config['hierarchical_pages'] = site.pages.map {
        |p| PageItem.new(p, priorities)
      }.sort {
        |a, b| a <=> b
      }.map{
        |i| i.page
      }
    end

  end

end
