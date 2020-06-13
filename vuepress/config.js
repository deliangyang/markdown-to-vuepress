const sidebar = require('./sidebar')
const nav = require('./nav')
const compile = require('./compile')

module.exports = {
  title: 'docs',
  description: 'party docs',
  themeConfig: {
    repo: 'x',
    repoLabel: '更新文档:' + compile.lastTime,
    docsRepo: 'x',
    docsDir: 'docs',
    docsBranch: 'master',
    editLinks: true,
    editLinkText: 'Edit this page on GitLab',
    nav: nav,
    sidebar: {
      '/': sidebar,
    },
  },
  extraWatchFiles: [
    '.vuepress/sidebar.js',
    '.vuepress/nav.js',
  ],
  plugins: [
    [
      '@vuepress/last-updated',
      {
        dateOptions:{
          hour12: false
        }
      }
    ],
    '@vuepress/back-to-top',
    'mermaidjs',
    [ 
      '@vuepress/search', {
        searchMaxSuggestions: 10
      }
    ]
  ],
  markdown: {
    config: md => {
      md.use(require('markdown-it-mermaid'))
    }
  }
}