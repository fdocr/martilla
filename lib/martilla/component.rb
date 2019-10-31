module Martilla
  class Component
    def bash(command)
      `bash -c \"#{command}\"`
    end
  end
end
