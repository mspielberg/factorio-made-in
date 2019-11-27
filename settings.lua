data:extend{
  {
    type = "bool-setting",
    name = "made-in-show-vanilla",
    setting_type = "startup",
    default_value = false,
  },
  {
    type = "string-setting",
    name = "made-in-format",
    setting_type = "startup",
    default_value = "icons_and_names",
    allowed_values = { "oneline_icons", "oneline_names", "icons_and_names", },
  },
}
