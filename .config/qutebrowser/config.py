from qutebrowser.api import interceptor

# Change the argument to True to still load settings configured via autoconfig.yml
config.load_autoconfig(True)

# Cookies accept
config.set('content.cookies.accept', 'all', 'chrome-devtools://*')
config.set('content.cookies.accept', 'all', 'devtools://*')

# Load images automatically in web pages.
config.set('content.images', True, 'chrome-devtools://*')
config.set('content.images', True, 'devtools://*')

# Enable JavaScript.
config.set('content.javascript.enabled', True, 'chrome-devtools://*')
config.set('content.javascript.enabled', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome://*/*')
config.set('content.javascript.enabled', True, 'qute://*/*')
config.set('content.javascript.enabled', True, 'file://*/*')
config.set('content.javascript.enabled', False, 'https://www.youtube.com/')

# Enable JavaScript for local pages
localhost = [ f'*://localhost:{x}/*' for x in ['3000', '4200', '8384', '8080'] ]
server = [ f'*://192.168.10.160:{x}/*' for x in ['3000', '4200', '8384', '8080'] ]
enableJS = []
enableJS.extend(localhost)
enableJS.extend(server)

for domain in enableJS:
    with config.pattern(domain) as pattern:
        pattern.content.javascript.enabled = True

# DuckDuckgo
duckduckgo = 'https://duckduckgo.com/?kae=d&kn=-1&kah=us-en%2Cpl-pl&kl=us-en&q={}'
config.set('url.default_page', duckduckgo)
config.set('url.searchengines', {
    'DEFAULT': duckduckgo
})

# Colors
darkColor = '#212337'
darkColorPlus = '#323448'
lightBlue = '#86e1fc'
selectedTab = lightBlue
unselectedTab = '#55cc80'
selectedPinTab = '#2E8B57'
whiteColor = 'white'

# Tabs bar
config.set('colors.tabs.bar.bg', darkColor)

config.set('colors.tabs.odd.bg', darkColor)
config.set('colors.tabs.odd.fg', unselectedTab)
config.set('colors.tabs.selected.odd.bg', darkColor)
config.set('colors.tabs.selected.odd.fg', selectedTab)

config.set('colors.tabs.even.bg', darkColor)
config.set('colors.tabs.even.fg', unselectedTab)
config.set('colors.tabs.selected.even.bg', darkColor)
config.set('colors.tabs.selected.even.fg', selectedTab)

config.set('colors.tabs.pinned.even.bg', darkColor)
config.set('colors.tabs.pinned.even.fg', unselectedTab)
config.set('colors.tabs.pinned.selected.even.bg', selectedPinTab)
config.set('colors.tabs.pinned.selected.even.fg', "white")

config.set('colors.tabs.pinned.odd.bg', darkColor)
config.set('colors.tabs.pinned.odd.fg', unselectedTab)
config.set('colors.tabs.pinned.selected.odd.bg', selectedPinTab)
config.set('colors.tabs.pinned.selected.odd.fg', "white")

# Status bar
config.set('colors.statusbar.normal.bg', darkColor)
config.set('colors.statusbar.command.bg', darkColor)

config.set('colors.statusbar.url.fg', unselectedTab)
config.set('colors.statusbar.url.success.https.fg', unselectedTab)
config.set('colors.statusbar.url.success.http.fg', unselectedTab)

# Completions
config.set('colors.completion.item.selected.bg', lightBlue)
config.set('colors.completion.item.selected.border.bottom', lightBlue)
config.set('colors.completion.item.selected.border.top', lightBlue)

config.set('colors.completion.category.bg', darkColor)
config.set('colors.completion.category.border.bottom', darkColor)
config.set('colors.completion.category.border.top', darkColor)

config.set('colors.completion.match.fg', unselectedTab)
config.set('colors.completion.even.bg', darkColorPlus)
config.set('colors.completion.odd.bg', darkColorPlus)

# Download bar
config.set('colors.downloads.bar.bg', darkColor)
config.set('colors.downloads.start.bg', darkColor)
config.set('colors.prompts.bg', darkColor)

config.set('downloads.position', 'bottom')
config.set('downloads.remove_finished', 5000)

# Tabs
config.set('tabs.padding', {
    'bottom': 10,
    'top': 10,
    'left': 5,
    'right': 5,
})

config.set('tabs.favicons.scale', 1.5)

# Search
config.set('search.ignore_case', 'always')

# Confirm quit
config.set('confirm_quit',["downloads"])

#
# Binds
#
config.unbind('J', mode='normal')
config.unbind('K', mode='normal')

config.bind('J', 'tab-prev')
config.bind('K', 'tab-next')

#
# Filters
#
def filter_yt(info: interceptor.Request):
    """
    Block the given request if necessery
    """
    url = info.request_url

    if url.host() == 'www.youtube.com' and url.path() == '/get_video_info' and '&adformat=' in url.query():
        info.block()

interceptor.register(filter_yt)
