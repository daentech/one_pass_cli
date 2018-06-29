require "one_pass_cli/version"
require 'clamp'
require 'json'
require 'rotp'
require 'uri'
require 'cgi'
require 'os'
require 'clipboard'

module OnePassCli
  
  $export_session

  Clamp do

    option "--show", :flag, "shows the password rather than copying it to the clipboard"
  
    parameter "subdomain", "The name of the subdomain you want to look in", attribute_name: :subdomain
    parameter "item name ...", "The name of the item you're searching for", attribute_name: :name
  
    def execute
      login()
      value = `#{$export_session} && op list items`
      hash = JSON.parse(value)
  
      matches = hash.select { |item| contains_filter(item) }
  
      if matches.size == 0
        print("No matching password found")
      elsif matches.size == 1
        handle_password(matches[0])
      else
        matches.each_with_index { |item, index| print("#{index}\t#{item['overview']['title']}\n") }
        puts "Select an option: "
        result = STDIN.gets.chomp
  
        if result =~ /^-?[0-9]+$/ && result.to_i < matches.size
          handle_password(matches[result.to_i])
        else
          puts "Invalid input."
        end
      end
    end
  
    def login
      # TODO Check the user is logged in
      $export_session = `op signin #{subdomain}`.split("\n")[0]
    end
  
    def contains_filter(item) 
      return match_all?(item['overview']['title'], name) || match_all?(item['overview']['url'], name)
    end
  
    def match_all? str, words
      words.all? {|w| str =~ /\b#{ Regexp.quote w }\b/i }
    end
  
    def handle_password(item)
      uuid = item['uuid']
      item_response = `#{$export_session} && op get item #{uuid}`
      result = JSON.parse(item_response)
  
      result['details']['fields'].each { |field|
        if show? || field['designation'] != 'password'
          print("#{field['name']}: #{field['value']}\n")
        else
          copy_to_clipboard(field['value'])  
        end
      }
  
      # Handle 2FA
      if result['details']['sections'] != nil
        result['details']['sections'].each { |section| 
          unless section['fields'].nil?
            section['fields'].each { |field|
              if field['v'].start_with?("otpauth://")
                parsed_uri = CGI::parse(URI::parse(field['v']).query)
                totp = ROTP::TOTP.new(parsed_uri['secret'][0])
                print("#{field['t']}: #{totp.now}")
              else
                print("#{field['t']}: #{field['v']}\n")
              end
            }
          end
        }
      end
    end
  
    def copy_to_clipboard(value)
      # Linux: You will need the xclip or xsel program. On debian/ubuntu this is: sudo apt-get install xclip
      Clipboard.copy(value)
      print("Password copied to clipboard\n")
    end
  
  end
  
end
