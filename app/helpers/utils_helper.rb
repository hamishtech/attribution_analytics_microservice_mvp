module UtilsHelper
  def parse_utm_params(url)
    return {} if url.blank?

    uri = URI.parse(url)
    return {} if uri.query.blank?

    query_params = CGI.parse(uri.query)
    utms = {}

    %w[utm_source utm_medium utm_campaign utm_content].each do |utm|
      utms[utm] = query_params[utm].first if query_params[utm].present?
    end

    utms
  end

  def parse_domain(url)
    return nil if url.nil?

    begin
      uri = URI.parse(url)
    rescue URI::InvalidURIError
      return nil
    end

    host = uri.host
    return nil if host.nil?

    host.start_with?('www.') ? host[4..-1] : host
  end
end
