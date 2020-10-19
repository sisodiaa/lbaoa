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

  def svg_icon_house
    tag.svg(
      width: '1.25em',
      height: '1.25em',
      viewBox: '0 0 16 16',
      class: 'bi bi-house',
      fill: 'currentColor',
      xmlns: 'http://www.w3.org/2000/svg'
    ) do
      concat(svg_icon_path_house1)
      concat(svg_icon_path_house2)
    end
  end

  def svg_icon_path_house1
    tag.path(
      'fill-rule': 'evenodd',
      d: <<~GEOM
        M2 13.5V7h1v6.5a.5.5 0 0 0 .5.5h9a.5.5 0 0 0 .5-.5V7h1v6.5a1.5 1.5 0 0 
        1-1.5 1.5h-9A1.5 1.5 0 0 1 2 13.5zm11-11V6l-2-2V2.5a.5.5 0 0 1 
        .5-.5h1a.5.5 0 0 1 .5.5z
      GEOM
    )
  end

  def svg_icon_path_house2
    tag.path(
      'fill-rule': 'evenodd',
      d: <<~GEOM
        M7.293 1.5a1 1 0 0 1 1.414 0l6.647 6.646a.5.5 0 0 1-.708.708L8 2.207 
        1.354 8.854a.5.5 0 1 1-.708-.708L7.293 1.5z
      GEOM
    )
  end

  def svg_icon_telephone
    tag.svg(
      svg_icon_path_telephone,
      width: '1.25em',
      height: '1.25em',
      viewBox: '0 0 16 16',
      class: 'bi bi-telephone',
      fill: 'currentColor',
      xmlns: 'http://www.w3.org/2000/svg'
    )
  end

  def svg_icon_path_telephone
    tag.path(
      'fill-rule': 'evenodd',
      d: <<~GEOM
        M3.654 1.328a.678.678 0 0 0-1.015-.063L1.605 2.3c-.483.484-.661 
        1.169-.45 1.77a17.568 17.568 0 0 0 4.168 6.608 17.569 17.569 0 0 0 
        6.608 4.168c.601.211 1.286.033 1.77-.45l1.034-1.034a.678.678 0 0 
        0-.063-1.015l-2.307-1.794a.678.678 0 0 0-.58-.122l-2.19.547a1.745 
        1.745 0 0 1-1.657-.459L5.482 8.062a1.745 1.745 0 0 
        1-.46-1.657l.548-2.19a.678.678 0 0 0-.122-.58L3.654 
        1.328zM1.884.511a1.745 1.745 0 0 1 2.612.163L6.29 
        2.98c.329.423.445.974.315 1.494l-.547 2.19a.678.678 0 0 0 
        .178.643l2.457 2.457a.678.678 0 0 0 .644.178l2.189-.547a1.745 1.745 0 
        0 1 1.494.315l2.306 1.794c.829.645.905 1.87.163 2.611l-1.034 
        1.034c-.74.74-1.846 1.065-2.877.702a18.634 18.634 0 0 1-7.01-4.42 
        18.634 18.634 0 0 1-4.42-7.009c-.362-1.03-.037-2.137.703-2.877L1.885.511z
      GEOM
    )
  end

  def svg_icon_envelope
    tag.svg(
      svg_icon_path_envelope,
      width: '1.25em',
      height: '1.25em',
      viewBox: '0 0 16 16',
      class: 'bi bi-envelope-open',
      fill: 'currentColor',
      xmlns: 'http://www.w3.org/2000/svg'
    )
  end

  def svg_icon_path_envelope
    tag.path(
      'fill-rule': 'evenodd',
      d: <<~GEOM
        M8.47 1.318a1 1 0 0 0-.94 0l-6 3.2A1 1 0 0 0 1 5.4v.818l5.724 3.465L8 
        8.917l1.276.766L15 6.218V5.4a1 1 0 0 0-.53-.882l-6-3.2zM15 7.388l-4.754 
        2.877L15 13.117v-5.73zm-.035 6.874L8 10.083l-6.965 4.18A1 1 0 0 0 2 
        15h12a1 1 0 0 0 .965-.738zM1 13.117l4.754-2.852L1 
        7.387v5.73zM7.059.435a2 2 0 0 1 1.882 0l6 3.2A2 2 0 0 1 16 5.4V14a2 2 0 
        0 1-2 2H2a2 2 0 0 1-2-2V5.4a2 2 0 0 1 1.059-1.765l6-3.2z
      GEOM
    )
  end
end
