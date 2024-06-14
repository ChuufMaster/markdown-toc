# 🧐 What is markdown-toc?

A Neovim plugin to generate, update and delete TOCs (Table of Contents) in a
markdown file from another markdown files headings

## 🗂️ Markdown-TOC TOC

- [🧐 What is markdown-toc?](<#-what-is-markdown-toc?>)
  - [🗂️ Markdown-TOC TOC](<#-markdown-toc-toc>)
  - [✨ Features](<#-features>)
  - [⚡️ Requirements](<#-requirements>)
  - [📦 Installation](<#-installation>)
  - [🚀 Usage](<#-usage>)
  - [⚙️ Configuration](<#-configuration>)

## ✨ Features

- Telescope picker to select the file to generate the TOC from
- Customisable level of headings to generate
- Customisable format string
- Update a table if you are inside of TOC it when calling `GenerateTOC`
- Markdown-TOC uses relative file paths so you won't have to worry about where
  the file you are using to generate the TOC is

## ⚡️ Requirements

- Neovim >=0.10
- [Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

## 📦 Installation

Install the plugin with your preferred package manager:

### 💤 [Lazy.nvim](https://github/folke/lazy.nvim)

```lua
return {
  {
    'ChuufMaster/markdown-toc'
    opts = {

      -- The heading level to match (i.e the number of "#"s to match to) max 6
      heading_level_to_match = -1,

      -- Set to True display a dropdown to allow you to select the heading level
      ask_for_heading_level = false,

      -- TOC default string
      -- WARN
      toc_format = '%s- [%s](<%s#%s>)',
    }
  },
}
```

## 🚀 Usage

**Markdown TOC** exposes 2 commands to the user:

- **GenerateTOC**: this opens up a telescope prompt for your `cwd` to select an
  markdown file to generate the TOC from
- **GenerateTOC**: can also take in 1 argument as a number which will set the
  heading level to that argument overriding the default heading level set in
  your config and will also ignore if you set to ask for heading level

- **DeleteTOC**: If your cursor is inside of a TOC matching when calling this command
  the default TOC format it will delete the table

## ⚙️ Configuration

markdown-toc comes with the following defaults:

```lua
{
  -- The heading level to match (i.e the number of "#"s to match to)
  heading_level_to_match = -1,

  -- Set to display a dropdown to allow you to select the heading level
  ask_for_heading_level = true,

  -- TOC default string
  -- The first %s is for indenting/tabs
  -- The sencond %s is for the original headings text
  -- The third %s is for the markdown files path that the TOC is being generated
  -- from
  -- The forth %s is for the target heading using the markdown rules
  toc_format = '%s- [%s](<%s#%s>)',
}
```
