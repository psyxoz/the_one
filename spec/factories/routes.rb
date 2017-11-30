FactoryBot.define do
  factory :route, class: Hash do
    initialize_with { attributes }
    skip_create

    start_node 'alpha'
    end_node 'gamma'
    start_time { Time.now.strftime('%FT%T') }
    end_time { Time.now.strftime('%FT%T') }
  end
end
