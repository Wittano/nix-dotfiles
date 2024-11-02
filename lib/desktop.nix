{ lib, ... }:
with lib;
{
  mkMultiUserHomeManager = users: config:
    assert builtins.typeOf users == "list";
    assert builtins.typeOf config == "set";
    builtins.listToAttrs (
      builtins.map
        (x: {
          name = x;
          value = config;
        })
        users);

  mkDesktopAssertion = config: users:
    assert builtins.typeOf config == "set";
    assert builtins.typeOf users == "list"; [{
      assertion = lists.any (x: !config.users.users.${x}.isNormal or false) users;
      message = "All users must be normal";
    }];
}
