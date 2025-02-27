# frozen_string_literal: true

require 'test_helper'

class RefuteEmptyTest < Minitest::Test
  def test_registers_offense_when_using_refute_with_empty
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(somestuff.empty?)
          ^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_empty(somestuff)` over `refute(somestuff.empty?)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_empty(somestuff)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_with_empty_and_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(somestuff.empty?, 'message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_empty(somestuff, 'message')` over `refute(somestuff.empty?, 'message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_empty(somestuff, 'message')
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_with_empty_and_heredoc_message
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(somestuff.empty?, <<~MESSAGE
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_empty(somestuff, <<~MESSAGE)` over `refute(somestuff.empty?, <<~MESSAGE)`.
            message
          MESSAGE
          )
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_empty(somestuff, <<~MESSAGE
            message
          MESSAGE
          )
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_with_empty_in_redundant_parentheses
    assert_offense(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute((somestuff.empty?))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_empty(somestuff)` over `refute(somestuff.empty?)`.
        end
      end
    RUBY

    assert_correction(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_empty((somestuff))
        end
      end
    RUBY
  end

  def test_refute_empty_method
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute_empty(somestuff)
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_refute_empty_method_with_any_arguments
    assert_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        def test_do_something
          refute(File.empty?(path))
        end
      end
    RUBY
  end
end
