# nvim-springtime
### A blazingly fast and custimizable Spring project creator
*Neovim plugin based on [Spring Initializr](https://start.spring.io) written in Lua and Rust*

## Caveats
- This plugin is made in Lua and Rust. So [Rust & Cargo](https://www.rust-lang.org/) must be installed.
- Extra dependencies must be installed required by rust crates, like: `libcurl, libclang, cmake`. 
- Old Spring Boot and Java versions could be used in this plugin unlike [Spring Initializr](https://start.spring.io).
- Default selected values could be changed by the user.
- Dependencies with autocomplete libraries.
- This plugin has been developed on and for `Linux` following open source philosophy.


<img src="https://github.com/javiorfo/img/blob/master/nvim-springtime/springtime.png?raw=true" alt="springtime" />


## Installation
`Packer`
```lua
use {
    'javiorfo/nvim-springtime',
    branch = 'rust',
    requires = {
        "javiorfo/nvim-popcorn",
        "javiorfo/nvim-spinetta",
        "hrsh7th/nvim-cmp"
    },
    run = function()
        require'springtime.core'.build()
    end,
}
```

`Lazy`
```lua
{ 
    'javiorfo/nvim-springtime',
    lazy = true,
    branch = 'rust',
    cmd = { "Springtime", "SpringtimeUpdate", "SpringtimeBuild" },
    dependencies = {
        "javiorfo/nvim-popcorn",
        "javiorfo/nvim-spinetta",
        "hrsh7th/nvim-cmp"
    },
    build = function()
        require'springtime.core'.build()
    end,
    opts = {
        -- This section is optional
        -- If you want to change default configurations
        -- In packer.nvim use require'springtime'.setup { ... }
        
        -- Springtime popup section
        spring = {
            -- Project: Gradle, Gradle Kotlin and Maven (Gradle default)
            project = {
                selected = 1
            },
            -- Language: Java, Kotlin and Groovy (Java default)
            language = {
                selected = 1
            },
            -- Packaging: Jar and War (Jar default)
            packaging = {
                selected = 1
            },
            -- Project Metadata defaults:
            -- Change the default values as you like
            -- This can also be edited in the popup
            project_metadata = {
                group = "com.example",
                artifact = "demo",
                name = "demo",
                package_name = "com.example.demo",
                version = "0.0.1-SNAPSHOT"
            }
        },

        -- Some popup options
        dialog = {
            -- The keymap used to select radio buttons (normal mode)
            selection_keymap = "<C-Space>",

            -- The keymap used to generate the Spring project (normal mode)
            generate_keymap = "<C-CR>",

            -- If you want confirmation before generate the Spring project
            confirmation = true,

            -- Highlight links to Title and sections for changing colors
            style = {
                title_link = "Boolean",
                section_link = "Type"
            }
        },

        -- Workspace is where the generated Spring project will be saved
        workspace = {
            -- Default where Neovim is open
            path = vim.fn.expand("%:p:h"),
            
            -- Spring Initializr generates a zip file
            -- Decompress the file by default
            decompress = true,

            -- If after generation you want to open the folder
            -- Opens the generated project in Neovim by default
            open_auto = true
        },

        -- This could be enabled for debugging purposes
        -- Generates a springtime.log with debug and errors.
        internal = {
            log_debug = false
        }
    }
}
```


## Usage
- Once **Springtime** is enabled. You can execute the command `:Springtime` to open the popup
- **Considerations:**
    - *Visual Mode* is disabled.
    - *Insert Mode* is only enable to edit **Project Metadata** and **Dependencies** 
    - To select radio buttons use default **Ctrl + Space** in *Normal mode* (or configure it like opts above)
    - To generate a project use default **Ctrl + CR** in *Normal mode* (or configure it like opts above)
    - **Dependencies** has autocomplete libraries

<img src="https://github.com/javiorfo/img/blob/master/nvim-springtime/springtime.gif?raw=true" alt="springtime" />

**NOTE:** The colorscheme **umbra** from [nvim-nyctophilia](https://github.com/javiorfo/nvim-nyctophilia) is used in this image


- By default Spring Boot versions and Java versions are extracted from [Spring Initializr](https://start.spring.io). For instance, if you want to use Spring Boot 2.X and Java 11 among others:
```lua
-- Example lazy.nvim
opts = {
    spring = {
        spring_boot = {
            selected = 3,
            values = {
                "3.2.5",
                "3.1.11",
                "2.7.18"
            }
        },
        java_version = {
            selected = 2,
            values = { 17, 11, 8 }
        }
    }
}
```

- You would get this:

<img src="https://github.com/javiorfo/img/blob/master/nvim-springtime/springtime2.png?raw=true" alt="springtime2" />

**NOTE:** The colorscheme **umbra** from [nvim-nyctophilia](https://github.com/javiorfo/nvim-nyctophilia) is used in this image



### List of commands:
| Command | Description                       |
| -------------- | --------------------------------- |
| `:Springtime`  | This command will open Springtime |
| `:SpringtimeBuild` | This command will build Rust code with cargo and update the plugin (executing :SpringtimeUpdate inside) |
| `:SpringtimeLogs`   | This command will open a buffer with the generated plugin logs |
| `:SpringtimeUpdate` | This command will update the libraries and Spring settings |


## Troubleshooting and recommendations
#### Springtime update recommendation
This plugin will download all the Spring libraries names, Java versions and Spring Boot versions used at the time when building. There is no process to update these files daily, so to match always to [Spring Initializr](https://start.spring.io) you can do the following:
- Execute the command `:SpringtimeUpdate` to update the aforementioned files every time you want.
- Or delegates this updating process to the package manager. So the upgrade is made every time this plugin is loaded. Example in lazy.nvim:
```lua
-- lazy.nvim
config = {
    require'springtime.core'.update()
}
```

#### Springtime build problems
When this plugin is downloaded and installed (with any package manager described above), a build is run from behind. This process builds the Rust source code into a library and executes some bash commands (It takes several seconds).
- If it fails **Springtime** could not be used. So check the logs with the command `:SpringtimeLogs`. Something like this could be found:

```bash
[ERROR][04/28/2024 12:53:02]: Unable to find libclang: "couldn't find any valid shared libraries matching: ['libclang.so', 'libclang-*.so', 'libclang.so.*', 'libclang-*.so.*'], set the `LIBCLANG_PATH` environment variable to a path where one of these files can be found (invalid: [])"
```

- It means that *libclang* is not installed (a dependency required by Rust)
- To solve it:
    - Install the library
    - Run the command `:SpringtimeBuild` in Neovim to execute the build again
    - Wait for the process to finish correctly
    - If an error ocurred again, repeat the steps checking the logs

#### Other problems
Enable the debug and errors log to check for any other problems. And please, report it [here](https://github.com/javiorfo/nvim-springtime/issues)
- Enable logs:
```lua
require'springtime'.setup {
    internal = {
        log_debug = true
    }
}

-- OR in lazy.nvim
opts = {
    internal = {
        log_debug = true
    }
}
```

---


### Donate
- **Bitcoin** [(QR)](https://raw.githubusercontent.com/javiorfo/img/master/crypto/bitcoin.png)  `1GqdJ63RDPE4eJKujHi166FAyigvHu5R7v`
- [Paypal](https://www.paypal.com/donate/?hosted_button_id=FA7SGLSCT2H8G)
