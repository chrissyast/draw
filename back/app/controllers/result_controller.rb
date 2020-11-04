class ResultController < ApplicationController
skip_before_action :verify_authenticity_token
  def calculation
    people = params["people"]
    result = make_draw(people)
    result_entry = Result.new({result: result})
    result_entry.save

    render :json => {result: result, id: result_entry.id}
  end

  def load
    id = params["id"]
    result = Result.find_by_id(id)
    render :json => {result: result.result}
  end
  
  def make_draw(people)
    while true
      buyers  = people
      recipients = buyers.dup
      results = {}
      success = true

      buyers.each do |buyer|
        if recipients.size == 1 && buyer.to_s == recipients[0].to_s
          success = false
          next
        end
        rec = recipients.sample
        while rec.to_s == buyer.to_s
          rec = recipients.sample
        end
        results[buyer] = rec
        recipients.delete(rec)
      end

      next unless success

      if recipients.empty?
        break
      end

    end
    results
  end
  
end
