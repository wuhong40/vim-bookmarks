" define source
function! unite#sources#bm#define()
    return [s:source]
endfunction

let s:source = {
\   'name': 'bm',
\   'description': 'candidates from vim_bookmarks',
\   'max_candidates': 200,
\   'syntax': 'uniteSource__Bm',
\}

function! s:source.gather_candidates(args, context)
  let files = sort(bm#all_files())
  let candidates = []
  for file in files
    let line_nrs = sort(bm#all_lines(file), "bm#compare_lines")
    for line_nr in line_nrs
      let bookmark = bm#get_bookmark_by_line(file, line_nr)
      let content = bookmark['annotation'] !=# ''
            \ ? "Annotation: ". bookmark['annotation']
            \ : (bookmark['content'] !=# ""
            \   ? bookmark['content']
            \   : "empty line")
      " call add(locations, file .":". line_nr .":". content)
      call add(candidates, {
                  \'word' : content,
                  \'abbr' : printf('%-32s%s',
                  \                 fnamemodify(file, ':.') . ':' . line_nr, content),
                  \ 'kind': 'jump_list',
                  \ 'action__path': file,
                  \ 'action__line' : line_nr,
                  \})
    endfor
  endfor
  return candidates
    " let projs = map(g:proj_list, "{
    "       \ 'word': v:val.name,
    "       \ 'abbr': printf('%-32s%s',
    "       \                 v:val.name,
    "       \                 fnamemodify(v:val.dir, ':~')
    "       \               ),
    "       \ 'kind' : 'proj',
    "       \ 'action__path' : fnamemodify(v:val.dir, ':p'),
    "       \ }")
    "
    " return []
endfunction
