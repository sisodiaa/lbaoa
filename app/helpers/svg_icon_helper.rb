module SvgIconHelper
  def svg_icon_person
    tag.svg(
      svg_icon_path_person,
      width: '1.25em',
      height: '1.25em',
      viewBox: '0 0 16 16',
      class: 'bi bi-person',
      fill: 'currentColor',
      xmlns: 'http://www.w3.org/2000/svg',
      style: 'vertical-align: text-top;'
    )
  end

  def svg_icon_path_person
    tag.path(
      'fill-rule': 'evenodd',
      d: <<~GEOM
        M13 14s1 0 1-1-1-4-6-4-6 3-6 4 1 1 1 1h10zm-9.995-.944v-.002.002zM3.022 
        13h9.956a.274.274 0 0 0 .014-.002l.008-.002c-.001-.246-.154-.986-.832-1.664C11.516 
        10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 
        1.664a1.05 1.05 0 0 0 .022.004zm9.974.056v-.002.002zM8 7a2 2 0 1 0 0-4 
        2 2 0 0 0 0 4zm3-2a3 3 0 1 1-6 0 3 3 0 0 1 6 0z
      GEOM
    )
  end
end
