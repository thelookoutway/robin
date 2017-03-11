module Operation
  class Base
    private

    def success
      Result.new(status: :success)
    end

    def failure
      Result.new(status: :failure)
    end
  end

  class Result
    attr_reader :status

    def initialize(status:)
      @status = status
    end

    def success?
      @status == :success
    end
  end
end
