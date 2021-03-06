require 'securerandom'
require 'closed_struct'

module RubyEventStore
  class Event
    def initialize(event_id: SecureRandom.uuid, metadata: {}, data: {})
      @event_id = event_id.to_s
      @metadata = ClosedStruct.new(metadata)
      @data     = ClosedStruct.new(data)
    end
    attr_reader :event_id, :metadata, :data

    def to_h
      {
          event_id:   event_id,
          metadata:   metadata.to_h,
          data:       data.to_h
      }
    end

    def timestamp
      metadata.timestamp rescue nil
    end

    def ==(other_event)
      other_event.instance_of?(self.class) &&
        other_event.event_id.eql?(event_id) &&
        other_event.data.eql?(data)
    end

    alias_method :eql?, :==
  end
end
