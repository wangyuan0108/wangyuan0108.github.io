{% if page.comments && theme.gitalk.enable %}
  <link rel="stylesheet" href="https://unpkg.com/gitalk/dist/gitalk.css">
  <script src="https://unpkg.com/gitalk/dist/gitalk.min.js"></script>
  <div id="gitalk-container"></div>
  <script type="text/javascript">
    var gitalk = new Gitalk({
      // id: location.pathname,
      // distractionFreeMode: '{{ theme.gitalk.distractionFreeMode }}'
      id: (location.pathname).split("/").pop().substring(0, 49),
      distractionFreeMode: true,
      clientID: '{{ theme.gitalk.clientID }}',
      clientSecret: '{{ theme.gitalk.clientSecret }}',
      repo: '{{ theme.gitalk.repo }}',
      owner: '{{ theme.gitalk.owner }}',
      admin: ['{{ theme.gitalk.admin }}'],
    })
    gitalk.render('gitalk-container')
  </script>
{% endif %}
