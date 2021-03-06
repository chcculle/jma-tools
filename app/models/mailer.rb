require 'action_mailer'
require 'date'

ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.view_paths= File.dirname(__FILE__)

  class Mailer < ActionMailer::Base
  
    def send_jma_email_confirm(name, amount, email)
      @name = name
      @amount = amount
      @email =  email
      time = Time.new
      @date = Time.local(time.year, time.month, time.day) 
      @date = Time.now.strftime("%b %d, %Y")
    
      ActionMailer::Base.smtp_settings = {
        :address   => ENV['JMA_ADDRESS'],
        :port      => ENV['JMA_PORT'],
        :domain    => ENV['JMA_DOMAIN'],
        :authentication => :"login",
        :tls =>         true,
        :user_name      => ENV['JMA_USER'],
        :password       => ENV['JMA_PASS'],
        :enable_starttls_auto => true,
      }
      
      puts "sending confirm to client at this address:  #{@email} from: #{ENV['JMA_FROM_ADDRESS']}"
      mail( 
        :to      =>  @email,
        :from    => ENV['JMA_FROM_ADDRESS'],
        :subject => "Thank You From Jody Michael Associates",
      ) do |format|
        format.html
        format.text
      end
    end
    
    def send_jma_email_payment_link(name, email, amount, category, coach)
      @name = name
      @email = email
      @amount = amount
      @category = category
      @coach = coach
      puts "send_jma_email_payment_link amount #{amount}"
      time = Time.new
      @date = Time.local(time.year, time.month, time.day) 
      @date = Time.now.strftime("%b %d, %Y")

      #puts "sending to: #{ENV['JMA_ADDRESS']}, #{ENV['JMA_PORT']} #{ENV['JMA_DOMAIN']}, #{ENV['JMA_USER']}, #{ENV['JMA_PASS']},  #{ENV['JMA_FROM_ADDRESS']},"
    
      ActionMailer::Base.smtp_settings = {
        :address   => ENV['JMA_ADDRESS'],
        :port      => ENV['JMA_PORT'],
        :domain    => ENV['JMA_DOMAIN'],
        :authentication => :"login",
        :tls =>         true,
        :user_name      => ENV['JMA_USER'],
        :password       => ENV['JMA_PASS'],
        :enable_starttls_auto => true,
      }
      mail( 
        :to      =>  @email,
        :from    => ENV['JMA_FROM_ADDRESS'],
        :subject => "Welcome To Jody Michael Associates",
      ) do |format|
        format.html
        format.text
      end
    end 
    
    def send_new_user_link(email, username)
      @email = email
      @username = username
    
      ActionMailer::Base.smtp_settings = {
        :address   => ENV['JMA_ADDRESS'],
        :port      => ENV['JMA_PORT'],
        :domain    => ENV['JMA_DOMAIN'],
        :authentication => :"login",
        :tls =>         true,
        :user_name      => ENV['JMA_USER'],
        :password       => ENV['JMA_PASS'],
        :enable_starttls_auto => true,
      }
      mail( 
        :to      =>  @email,
        :from    => ENV['JMA_FROM_ADDRESS'],
        :subject => "Welcome To Jody Michael Associates",
      ) do |format|
        format.html
        format.text
      end
    end
      
      
    
    def send_email(name, email, amount, category, appt_date, payment_date, appt_start, appt_end, coach, location,
      text1, text2, text3, text4, text5, interview_text1, interview_text2, interview_text3, template, payment_text, greeting,
      closing_text)
      @name = name
      @email = email
      @amount = amount
      @category = category
      @coach = coach
      @coach_name = coach.name
      @coach_email = coach.email
      @coach_phone = coach.phone
      @location = location
      @appt_date_formatted = appt_date
      @payment_date_formatted = payment_date
      @appt_start = appt_start
      @appt_end = appt_end
      @text1 = text1
      @text2 = text2
      @text3 = text3
      @text4 = text4
      @text5 = text5
      @interview_text1 = interview_text1
      @interview_text2 = interview_text2
      @interview_text3 = interview_text3
      @template = template
      @payment_text = payment_text
      @greeting = greeting
      @closing_text = closing_text

      begin
        
        ActionMailer::Base.smtp_settings = {
          :address   => ENV['JMA_ADDRESS'],
          :port      => ENV['JMA_PORT'],
          :domain    => ENV['JMA_DOMAIN'],
          :authentication => :"login",
          :tls =>         true,
          :user_name      => ENV['JMA_USER'],
          :password       => ENV['JMA_PASS'],
          :enable_starttls_auto => true,
        }
        puts "send_email closing_text #{@closing_text} location #{@location}  coach #{coach.name} amount #{amount} date #{@appt_date_formatted} payment date #{@payment_date_formatted} start #{@appt_start} end #{@appt_end}"
        mail( 
          :to      =>  @email,
          :from    => ENV['JMA_FROM_ADDRESS'],
          :subject => "Welcome To Jody Michael Associates",
        ) do |format|
          format.html
          format.text
        end
      rescue Exception => e
        puts "rescue caught in send_mail #{e.message}"
        @error_message = e.message
        puts e.backtrace 
      end
    end

    def send_initial_contact_email_with_pricing(name, email, text1, text2, text3, text4, closing_text, include_pricing_info)
      @name = name
      @email = email
      @text1 = text1
      @text2 = text2
      @text3 = text3
      @text4 = text4
      @closing_text = closing_text
      @include_pricing_info = include_pricing_info

      begin
        
        ActionMailer::Base.smtp_settings = {
          :address   => ENV['JMA_ADDRESS'],
          :port      => ENV['JMA_PORT'],
          :domain    => ENV['JMA_DOMAIN'],
          :authentication => :"login",
          :tls =>         true,
          :user_name      => ENV['KELLY_USER'],
          :password       => ENV['JMA_PASS'],
          :enable_starttls_auto => true,
        }
        puts "send_initial_contact_email #{@name}, #{@email}  #{@include_pricing_info}"
        if !@include_pricing_info.nil? && @include_pricing_info == "on"
          attachments['2015 JMA Career Discovery Package.pdf'] = File.read('public/images/2015 JMA Career Discovery Package.pdf')
        end
                mail( 
          :to      =>  @email,
          :from    => ENV['KELLY_USER'],
          :subject => "Jody Michael Associates Inquiry",
        ) do |format|
          format.html
          format.text
        end
      rescue Exception => e
        puts "rescue caught in send_initial_contact_email_with_pricing #{e.message}"
        @error_message = e.message
        puts e.backtrace 
      end
    end


    def send_hab_email(name, email, coach, text1, text2, text3, registration_key, report_type, closing_text)
      @name = name
      @email = email
      @coach  = coach
      @text1 = text1
      @text2 = text2
      @text3 = text3
      @registration_key = registration_key
      @report_type = report_type
      @closing_text = closing_text
      puts "mailer.send_hab_email() registration_key: #{@registration_key}"
      begin
        
        ActionMailer::Base.smtp_settings = {
          :address   => ENV['JMA_ADDRESS'],
          :port      => ENV['JMA_PORT'],
          :domain    => ENV['JMA_DOMAIN'],
          :authentication => :"login",
          :tls =>         true,
          :user_name      => ENV['KELLY_USER'],
          :password       => ENV['JMA_PASS'],
          :enable_starttls_auto => true,
        }
        puts "send_hab_email #{@name}, #{@email}  "

        attachments['Instruction Sheet - Highlands Ability Battery.pdf'] = File.read('public/images/Instruction Sheet - Highlands Ability Battery.pdf')
        attachments['Tips - Highlands Ability Battery.pdf'] = File.read('public/images/Tips - Highlands Ability Battery.pdf')
        
          mail( 
          :to      =>  @email + ", " + @coach.email,
          :from    => ENV['KELLY_USER'],
          :subject => "Your Highlands Ability Battery Key Code and Instructions",
        ) do |format|
          format.html
          format.text
        end
      rescue Exception => e
        puts "rescue caught in send_hab_email #{e.message}"
        @error_message = e.message
        puts e.backtrace 
      end
    end




    def send_pre_workshop_email(name, email, amount, appt_date, payment_date, appt_start, appt_end, location,
      text1, text2, text3, text4, text5, template, payment_text, greeting1, greeting2, closing_text)
      @name = name
      @email = email
      @amount = amount
      @appt_date_formatted = appt_date
      @payment_date_formatted = payment_date
      @appt_start = appt_start
      @appt_end = appt_end
      @text1 = text1
      @text2 = text2
      @text3 = text3
      @text4 = text4
      @text5 = text5
      @template = template
      @payment_text = payment_text
      @greeting1 = greeting1
      @greeting2 = greeting2
      @closing_text = closing_text
      begin
        
        ActionMailer::Base.smtp_settings = {
          :address   => ENV['JMA_ADDRESS'],
          :port      => ENV['JMA_PORT'],
          :domain    => ENV['JMA_DOMAIN'],
          :authentication => :"login",
          :tls =>         true,
          :user_name      => ENV['JMA_USER'],
          :password       => ENV['JMA_PASS'],
          :enable_starttls_auto => true,
        }
        #need a list of recipient emails here
        puts "sending email to #{@name}"
        attachments['JMA_Getting_Results.pdf'] = File.read('public/images/JMA_Getting_Results.pdf')
        mail( 
          :to      =>  @email,
          :from    => ENV['JMA_FROM_ADDRESS'],
          :subject => "JMA Accountability Mirror Workshop Info & Pre-work",
        ) do |format|
          format.html
          format.text
        end
      rescue Exception => e
        puts "rescue caught in send_pre_workshop_email #{e.message}"
        @error_message = e.message
        puts e.backtrace 
      end
    end

    def send_post_workshop_email(email, appt_date, payment_date, appt_start, greeting, text1, text2, text3, template, closing_text)
      @email = email
      @appt_date_formatted = appt_date
      @payment_date_formatted = payment_date
      @appt_start = appt_start
      @greeting = greeting
      @text1 = text1
      @text2 = text2
      @text3 = text3
      @template = template
      @closing_text = closing_text
      begin
        
        ActionMailer::Base.smtp_settings = {
          :address   => ENV['JMA_ADDRESS'],
          :port      => ENV['JMA_PORT'],
          :domain    => ENV['JMA_DOMAIN'],
          :authentication => :"login",
          :tls =>         true,
          :user_name      => ENV['JMA_USER'],
          :password       => ENV['JMA_PASS'],
          :enable_starttls_auto => true,
        }
        #need a list of recipient emails here
        puts "sending email to #{@name}"
        attachments['JMA_Goal_Matrix_Form.pdf'] = File.read('public/images/JMA_Goal_Matrix_Form.pdf')
        mail( 
          :to      =>  @email,
          :from    => ENV['JMA_FROM_ADDRESS'],
          :subject => "Accountability Mirror post-workshop homework",
        ) do |format|
          format.html
          format.text
        end
      rescue Exception => e
        puts "rescue caught in send_post_workshop_email #{e.message}"
        @error_message = e.message
        puts e.backtrace 
      end
    end
    
 
    
    def send_perpetual_lens_email(name, email, amount, appt_date, payment_date, appt_start, appt_end, location,
      text1, text2, text3, text4, text5, interview_text1, interview_text2, interview_text3, template, payment_text, greeting,
      closing_text)
      @name = name
      @email = email
      @amount = amount
      @location = location
      @appt_date_formatted = appt_date
      @payment_date_formatted = payment_date
      @appt_start = appt_start
      @appt_end = appt_end
      @text1 = text1
      @text2 = text2
      @text3 = text3
      @text4 = text4
      @text5 = text5
      @interview_text1 = interview_text1
      @interview_text2 = interview_text2
      @interview_text3 = interview_text3
      @template = template
      @payment_text = payment_text
      @greeting = greeting
      @closing_text = closing_text

      begin
        
        ActionMailer::Base.smtp_settings = {
          :address   => ENV['JMA_ADDRESS'],
          :port      => ENV['JMA_PORT'],
          :domain    => ENV['JMA_DOMAIN'],
          :authentication => :"login",
          :tls =>         true,
          :user_name      => ENV['JMA_USER'],
          :password       => ENV['JMA_PASS'],
          :enable_starttls_auto => true,
        }
        #need a list of recipient emails here
        attachments['Perceptual Lens Assessment Instructions.pdf'] = File.read('public/images/Perceptual Lens Assessment Instructions.pdf')
        puts "sending perpetual lense email to #{@email}"
        mail( 
          :to      =>  @email,
          :from    => ENV['JMA_FROM_ADDRESS'],
          :subject => "Welcome To Jody Michael Associates",
        ) do |format|
          format.html
          format.text
        end
      rescue Exception => e
        puts "rescue caught in send_perpetual_lens_email #{e.message}"
        @error_message = e.message
        puts e.backtrace 
      end
    end
   


    def credit_card_charged_email_to_jma_support(name, amount)
      @name = name
      @amount = amount
      time = Time.new
      @date = Time.local(time.year, time.month, time.day) 
      @date = Time.now.strftime("%b %d, %Y")
    
      ActionMailer::Base.smtp_settings = {
        :address   => ENV['JMA_ADDRESS'],
        :port      => ENV['JMA_PORT'],
        :domain    => ENV['JMA_DOMAIN'],
        :authentication => :"login",
        :tls =>         true,
        :user_name      => ENV['JMA_USER'],
        :password       => ENV['JMA_PASS'],
        :enable_starttls_auto => true,
      }
      mail( 
        :to      => ENV['JMA_SUPPORT_EMAIL'],
        :from    => ENV['JMA_FROM_ADDRESS'],
        :subject => "JMA Payment Received",
      ) do |format|
        format.html
        format.text
      end
    end
    
    
    def credit_card_info_received_to_jma_support(name, amount)
      @name = name
      @amount = amount
    
      ActionMailer::Base.smtp_settings = {
        :address   => ENV['JMA_ADDRESS'],
        :port      => ENV['JMA_PORT'],
        :domain    => ENV['JMA_DOMAIN'],
        :authentication => :"login",
        :tls =>         true,
        :user_name      => ENV['JMA_USER'],
        :password       => ENV['JMA_PASS'],
        :enable_starttls_auto => true,
      }
      puts "sending confirm to jma support team at this address:  #{ENV['JMA_SUPPORT_EMAIL']} from: #{ENV['JMA_FROM_ADDRESS']}"
      mail( 
        :to      => ENV['JMA_SUPPORT_EMAIL'],
        :from    => ENV['JMA_FROM_ADDRESS'],
        :subject => "JMA Payment Information Received",
      ) do |format|
        format.html
        format.text
      end
    end
 
  def send_jma_weekly_summary()
    
    begin    
      @date = Time.now.strftime("%b %d, %Y")
        
      ActionMailer::Base.smtp_settings = {
        :address   => ENV['JMA_ADDRESS'],
        :port      => ENV['JMA_PORT'],
        :domain    => ENV['JMA_DOMAIN'],
        :authentication => :"login",
        :tls =>         true,
        :user_name      => ENV['JMA_USER'],
        :password       => ENV['JMA_PASS'],
        :enable_starttls_auto => true,
      }

      mail( 
        :to      => ENV['DEVELOPER_EMAIL'] + ", jody@jodymichael.com, kelly@jodymichael.com",
       # :to      => ENV['DEVELOPER_EMAIL'],
        :from    => ENV['JMA_FROM_ADDRESS'],
        :subject => "JMA Weekly Payment Processing Summary",
      ) do |format|
        format.html
        format.text
      end
      
      rescue Exception => e
          puts "rescue caught in send_jma_weekly_summary #{e.message}"
          @error_message = e.message
          puts e.backtrace
      end
    end

     def send_yelp_request(name, email)
      @name = name
      @email =  email
    
      ActionMailer::Base.smtp_settings = {
        :address   => ENV['JMA_ADDRESS'],
        :port      => ENV['JMA_PORT'],
        :domain    => ENV['JMA_DOMAIN'],
        :authentication => :"login",
        :tls =>         true,
        :user_name      => ENV['JMA_USER'],
        :password       => ENV['JMA_PASS'],
        :enable_starttls_auto => true,
      }
      
      puts "sending yelp request to:  #{@email} from: #{ENV['JMA_FROM_ADDRESS']}"
      mail( 
        :to      =>  @email,
        :from    => ENV['JMA_FROM_ADDRESS'],
        :subject => "Thank you and ...",
      ) do |format|
        format.html
      end
    end
    
end
