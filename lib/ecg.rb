# frozen_string_literal: true

Dir[File.expand_path('ecg/*.rb', __dir__)].each(&method(:require))
