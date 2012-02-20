module Subscriptions
  module Helpers

    def item_path(item_type, item)
      "/#{item_type}/#{item.id}"
    end
    
    def bill_code(type, number)
      "#{bill_type type} #{number}"
    end
    
    # standardized in accordance with http://www.gpoaccess.gov/bills/glossary.html
    def bill_type(short)
      {
        "hr" => "H.R.",
        "hres" => "H.Res.",
        "hjres" => "H.J.Res.",
        "hcres" => "H.Con.Res.",
        "s" => "S.",
        "sres" => "S.Res.",
        "sjres" => "S.J.Res.",
        "scres" => "S.Con.Res."
      }[short]
    end
    
    def fulltext_highlight(item, keyword, priorities, highlight = true)
      highlighting = item.data['search']['highlight']
      field = highlighting.keys.sort_by {|k| priorities[k]}.first
      excerpt highlighting[field].first, keyword, highlight
    end

    def bill_highlight(item, keyword, highlight = true)
      fulltext_highlight item, keyword, bill_priorities, highlight
    end

    def regulation_highlight(item, keyword, highlight = true)
      fulltext_highlight item, keyword, regulation_priorities, highlight
    end
    
    def govtrack_type(bill_type)
      {
        "hr" => "h",
        "hres" => "hr",
        "hjres" => "hj",
        "hcres" => "hc",
        "s" => "s",
        "sres" => "sr",
        "sjres" => "sj",
        "scres" => "sc"
      }[bill_type]
    end
    
    # most are fine, just alter the con res's
    def thomas_type(bill_type)
      {
        "hcres" => "hconres",
        "scres" => "sconres"
      }[bill_type] || bill_type
    end
    
    def opencongress_url(item)
      bill = item.data
      id = "#{bill['session']}-#{govtrack_type bill['bill_type']}#{bill['number']}"
      "http://www.opencongress.org/bill/#{id}/show"
    end
    
    def govtrack_url(item)
      bill = item.data
      id = "#{govtrack_type bill['bill_type']}#{bill['session']}-#{bill['number']}"
      "http://www.govtrack.us/congress/bill.xpd?bill=#{id}"
    end
    
    def thomas_url(item)
      bill = item.data
      id = "#{bill['session']}#{thomas_type bill['bill_type']}#{bill['number']}"
      "http://hdl.loc.gov/loc.uscongress/legislation.#{id}"
    end

    # unused    
    def highlight_field(field)
      {
        "versions" => "the full text",
        "summary" => "the CRS summary",
        "official_title" => "the official title",
        "short_title" => "the shorthand title",
        "popular_title" => "the common parlance",
        "keywords" => "the tagged subjects"
      }[field]
    end
    
    def bill_priorities
      {
        "summary" => 1,
        "versions" => 2,
        "keywords" => 3,
        "official_title" => 4,
        "short_title" => 5,
        "popular_title" => 6
      }
    end

    def regulation_priorities
      {
        'abstract' => 1,
        'full_text' => 2,
        'title' => 3
      }
    end
    
    # adapted from http://www.gpoaccess.gov/bills/glossary.html
    def bill_version(code)
      {
        'ash' => "Additional Sponsors House",
        'ath' => "Agreed to House",
        'ats' => "Agreed to Senate",
        'cdh' => "Committee Discharged House",
        'cds' => "Committee Discharged Senate",
        'cph' => "Considered and Passed House",
        'cps' => "Considered and Passed Senate",
        'eah' => "Engrossed Amendment House",
        'eas' => "Engrossed Amendment Senate",
        'eh' => "Engrossed in House",
        'ehr' => "Engrossed in House-Reprint",
        'eh_s' => "Engrossed in House (No.) Star Print [*]",
        'enr' => "Enrolled Bill",
        'es' => "Engrossed in Senate",
        'esr' => "Engrossed in Senate-Reprint",
        'es_s' => "Engrossed in Senate (No.) Star Print",
        'fah' => "Failed Amendment House",
        'fps' => "Failed Passage Senate",
        'hdh' => "Held at Desk House",
        'hds' => "Held at Desk Senate",
        'ih' => "Introduced in House",
        'ihr' => "Introduced in House-Reprint",
        'ih_s' => "Introduced in House (No.) Star Print",
        'iph' => "Indefinitely Postponed in House",
        'ips' => "Indefinitely Postponed in Senate",
        'is' => "Introduced in Senate",
        'isr' => "Introduced in Senate-Reprint",
        'is_s' => "Introduced in Senate (No.) Star Print",
        'lth' => "Laid on Table in House",
        'lts' => "Laid on Table in Senate",
        'oph' => "Ordered to be Printed House",
        'ops' => "Ordered to be Printed Senate",
        'pch' => "Placed on Calendar House",
        'pcs' => "Placed on Calendar Senate",
        'pp' => "Public Print",
        'rah' => "Referred w/Amendments House",
        'ras' => "Referred w/Amendments Senate",
        'rch' => "Reference Change House",
        'rcs' => "Reference Change Senate",
        'rdh' => "Received in House",
        'rds' => "Received in Senate",
        're' => "Reprint of an Amendment",
        'reah' => "Re-engrossed Amendment House",
        'renr' => "Re-enrolled",
        'res' => "Re-engrossed Amendment Senate",
        'rfh' => "Referred in House",
        'rfhr' => "Referred in House-Reprint",
        'rfh_s' => "Referred in House (No.) Star Print",
        'rfs' => "Referred in Senate",
        'rfsr' => "Referred in Senate-Reprint",
        'rfs_s' => "Referred in Senate (No.) Star Print",
        'rh' => "Reported in House",
        'rhr' => "Reported in House-Reprint",
        'rh_s' => "Reported in House (No.) Star Print",
        'rih' => "Referral Instructions House",
        'ris' => "Referral Instructions Senate",
        'rs' => "Reported in Senate",
        'rsr' => "Reported in Senate-Reprint",
        'rs_s' => "Reported in Senate (No.) Star Print",
        'rth' => "Referred to Committee House",
        'rts' => "Referred to Committee Senate",
        'sas' => "Additional Sponsors Senate",
        'sc' => "Sponsor Change House",
        's_p' => "Star (No.) Print of an Amendment"
      }[code]
    end
    
    def state_name(code)
      {
        "AL" => "Alabama",
        "AK" => "Alaska",
        "AZ" => "Arizona",
        "AR" => "Arkansas",
        "CA" => "California",
        "CO" => "Colorado",
        "CT" => "Connecticut",
        "DE" => "Delaware",
        "DC" => "District of Columbia",
        "FL" => "Florida",
        "GA" => "Georgia",
        "HI" => "Hawaii",
        "ID" => "Idaho",
        "IL" => "Illinois",
        "IN" => "Indiana",
        "IA" => "Iowa",
        "KS" => "Kansas",
        "KY" => "Kentucky",
        "LA" => "Louisiana",
        "ME" => "Maine",
        "MD" => "Maryland",
        "MA" => "Massachusetts",
        "MI" => "Michigan",
        "MN" => "Minnesota",
        "MS" => "Mississippi",
        "MO" => "Missouri",
        "MT" => "Montana",
        "NE" => "Nebraska",
        "NV" => "Nevada",
        "NH" => "New Hampshire",
        "NJ" => "New Jersey",
        "NM" => "New Mexico",
        "NY" => "New York",
        "NC" => "North Carolina",
        "ND" => "North Dakota",
        "OH" => "Ohio",
        "OK" => "Oklahoma",
        "OR" => "Oregon",
        "PA" => "Pennsylvania",
        "PR" => "Puerto Rico",
        "RI" => "Rhode Island",
        "SC" => "South Carolina",
        "SD" => "South Dakota",
        "TN" => "Tennessee",
        "TX" => "Texas",
        "UT" => "Utah",
        "VT" => "Vermont",
        "VA" => "Virginia",
        "WA" => "Washington",
        "WV" => "West Virginia",
        "WI" => "Wisconsin",
        "WY" => "Wyoming"
      }[code.to_s.upcase]
    end
    
    def state_in_og?(code)
      ["CA", "LA", "MD", "MN", "TX"].include? code.to_s.upcase
    end
    
    def state_version_info?(bill)
      bill['versions'] and bill['versions'].any?
    end
    
    def state_source_info?(bill)
      bill['sources'] and bill['sources'].any?
    end
    
    def opengovernment_url(bill)
      state = bill['state'].to_s.downcase
      bill_id = bill['bill_id'].downcase.gsub(' ', '-')
      session = bill['session']
      
      # if state == "wi"
      #   session = bill['session'].downcase.gsub(' ', '-')
      # end
      
      "http://#{state}.opengovernment.org/sessions/#{session}/bills/#{bill_id}"
    end
    
    def speech_selection(speech, keyword)
      first = speech['speaking'].select do |paragraph|
        paragraph =~ excerpt_pattern(keyword)
      end.first
    end

    def speech_excerpt(speech, keyword, highlight = true)
      if selection = speech_selection(speech, keyword)
        excerpt selection, keyword, highlight
      end
    end

    def excerpt_pattern(keyword)
      /#{keyword.gsub(' ', '[\s\-]')}/i
    end
    
    # client-side truncation and highlighting
    def excerpt(text, keyword, highlight = true)

      text = text.strip
      word = keyword.size
      length = text.size
      
      index = text =~ excerpt_pattern(keyword) || 0
      max = 500
      buffer = 100

      range = nil
      if (length < max) || ((index + word) < (max - buffer))
        range = 0..max
      else
        finish = nil
        if (index + word + buffer) < length
          finish = index + word + buffer
        else
          finish = length
        end
        start = finish - max
        range = start..finish
      end

      truncated = text[range]
      truncated = "..." + truncated if (range.begin > 0) || (text[0..0].upcase != text[0..0])
      truncated = truncated + "..." if range.end < length

      if highlight
        truncated.gsub(excerpt_pattern(keyword)) do |word|
          "<em class=\"highlight\">#{word}</em>"
        end
      else
        truncated
      end
    end

    def truncate(string, length)
      if string.size > (length + 3)
        string[0...length] + "..."
      else
        string
      end
    end
    
    def speaker_name(speech)
      title = (speech['chamber'] == 'Senate') ? 'Sen' : 'Rep'
      party = speech['speaker_party']
      state = speech['speaker_state']
      "#{title}. #{speech['speaker_first']} #{speech['speaker_last']} (#{party}-#{state})"
    end
    
    def speaker_url(speech)
      "http://capitolwords.org/legislator/#{speech['bioguide_id']}"
    end

    def regulation_stage(stage)
      {
        :proposed => "Proposed Rule",
        :final => "Final Rule"
      }[stage.to_sym] || "Rule"
    end
  end
end