require "#{File.dirname(__FILE__)}/test_helper"
class KMLFileTest < Test::Unit::TestCase
  include KML
  
  def test_placemark
    kml = KMLFile.new
    kml.objects << Placemark.new(
      :name => 'Simple placemark', 
      :description => 'Attached to the ground. Intelligently places itself at the height of the underlying terrain.',
      :geometry => Point.new(:coordinates=>'-122.0822035425683,37.42228990140251,0')
    )
    write_and_show(kml, File.dirname(__FILE__) + '/simple_placemark.kml')
  end
  
  def test_cdata_description
    description = <<-DESC
<h1>CDATA Tags are useful!</h1>
<p><font color="red">Text is <i>more readable</i> and 
<b>easier to write</b> when you can avoid using entity 
references.</font></p>
DESC
    
    kml = KMLFile.new
    document = Document.new(
      :name => 'Document with CDATA example', 
      :snippet => Snippet.new("Document level snippet")
    )
    document.features << Placemark.new(
      :name => 'CDATA example', 
      :description => description,
      :snippet => Snippet.new("Example of a snippet"),
      :geometry => Point.new(:coordinates=>'-122.0822035425683,37.4228,0')
    )
    kml.objects << document
    write_and_show(kml, File.dirname(__FILE__) + '/cdata_and_snippet.kml')
  end
  
  def test_ground_overlays
    kml = KMLFile.new
    folder = Folder.new(
      :name => 'Ground Overlays',
      :description => 'Examples of ground overlays'
    )
    folder.features << GroundOverlay.new(
      :name => 'Large-scale overlay on terrain',
      :description => 'Overlay shows Mount Etna erupting on July 13th, 2001.',
      :icon => Icon.new(:href => 'http://code.google.com/apis/kml/documentation/etna.jpg'),
      :lat_lon_box => LatLonBox.new(
        :north => 37.91904192681665,
        :south => 37.46543388598137,
        :east => 15.35832653742206,
        :west => 14.60128369746704,
        :rotation => -0.1556640799496235
      )
    )
    kml.objects << folder
    write_and_show(kml, File.dirname(__FILE__) + '/ground_overlays.kml')
  end
  
  def test_paths
    kml = KMLFile.new
    kml.objects << Document.new(
      :name => 'Paths',
      :description => 'Examples of paths. Note that the tessellate tag is by default
            set to 0. If you want to create tessellated lines, they must be authored
            (or edited) directly in KML.',
      :styles => [
        Style.new(
          :id => 'yellowLineGreenPoly',
          :line_style => LineStyle.new(:color => '7f00ffff', :width => 4),
          :poly_style => PolyStyle.new(:color => '7f00ff00')
        )
      ],
      :features => [
        Placemark.new(
          :name => 'Absolute Extruded',
          :description => 'Transparent green wall with yellow outlines',
          :style_url => '#yellowLineGreenPoly',
          :geometry => LineString.new(
            :extrude => true,
            :tessellate => true,
            :altitude_mode => 'absolute',
            :coordinates => '-112.2550785337791,36.07954952145647,2357
                      -112.2549277039738,36.08117083492122,2357
                      -112.2552505069063,36.08260761307279,2357
                      -112.2564540158376,36.08395660588506,2357
                      -112.2580238976449,36.08511401044813,2357
                      -112.2595218489022,36.08584355239394,2357
                      -112.2608216347552,36.08612634548589,2357
                      -112.262073428656,36.08626019085147,2357
                      -112.2633204928495,36.08621519860091,2357
                      -112.2644963846444,36.08627897945274,2357
                      -112.2656969554589,36.08649599090644,2357'
          )
        )
      ]
    )
    #puts kml.render
    write_and_show(kml, File.dirname(__FILE__) + '/paths.kml')
  end
  
  def test_polygon
    kml = KMLFile.new
    kml.objects << Placemark.new(
      :name => 'The Pentagon',
      :geometry => Polygon.new(
        :extrude => true,
        :altitude_mode => 'relativeToGround',
        :outer_boundary_is => LinearRing.new(
          :coordinates => '-77.05788457660967,38.87253259892824,100 
                      -77.05465973756702,38.87291016281703,100 
                      -77.05315536854791,38.87053267794386,100 
                      -77.05552622493516,38.868757801256,100 
                      -77.05844056290393,38.86996206506943,100 
                      -77.05788457660967,38.87253259892824,100'
        ),
        :inner_boundary_is => LinearRing.new(
          :coordinates => '-77.05668055019126,38.87154239798456,100 
                      -77.05542625960818,38.87167890344077,100 
                      -77.05485125901024,38.87076535397792,100 
                      -77.05577677433152,38.87008686581446,100 
                      -77.05691162017543,38.87054446963351,100 
                      -77.05668055019126,38.87154239798456,100'
        )
      )
    )
    
    #puts kml.render
    write_and_show(kml, File.dirname(__FILE__) + '/polygon.kml')
  end
end