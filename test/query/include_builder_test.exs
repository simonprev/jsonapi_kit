defmodule JsonapiKitQueryIncludeBuilderTest do
  use ExUnit.Case
  doctest JsonapiKit.QueryIncludeBuilder

  @empty_config %JsonapiKit.QueryConfig{}

  test "nil include" do
    include = JsonapiKit.QueryIncludeBuilder.build(nil, @empty_config)
    assert include == []
  end

  test "empty string include" do
    include = JsonapiKit.QueryIncludeBuilder.build("", @empty_config)
    assert include == []
  end

  test "simple include" do
    include = JsonapiKit.QueryIncludeBuilder.build("user", @empty_config)
    assert include == [:user]
  end

  test "multiple simple include" do
    include = JsonapiKit.QueryIncludeBuilder.build("user,moment", @empty_config)
    assert include == [:user, :moment]
  end

  test "nested include" do
    include = JsonapiKit.QueryIncludeBuilder.build("user.organization", @empty_config)
    assert include == [user: :organization]
  end

  test "multiple nested include" do
    include = JsonapiKit.QueryIncludeBuilder.build("user,moment,moment.user,user.organization", @empty_config)
    assert include == [:user, :moment, {:moment, :user}, {:user, :organization}]
  end

  test "2 level nested include" do
    include = JsonapiKit.QueryIncludeBuilder.build("moment.user.organization", @empty_config)
    assert include == [moment: [user: :organization]]
  end

  test "with allowed includes" do
    config = %{@empty_config | options: [allowed_includes: ~w(user organization)]}

    include = JsonapiKit.QueryIncludeBuilder.build("user,moment", config)
    assert include == [:user]
  end

  test "with allowed nested includes" do
    config = %{@empty_config | options: [allowed_includes: ~w(organization moment.user)]}

    include = JsonapiKit.QueryIncludeBuilder.build("user,moment,moment.user", config)
    assert include == [moment: :user]
  end

  test "with always includes" do
    config = %{@empty_config | options: [always_includes: ~w(organization)]}

    include = JsonapiKit.QueryIncludeBuilder.build("user,moment", config)
    assert include == [:user, :moment, :organization]
  end
end
