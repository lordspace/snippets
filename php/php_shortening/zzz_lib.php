<?php


/**
 * A nice shorting class based on Ryan Charmley's suggestion see the link on stackoverflow below.
 * @author Svetoslav Marinov (Slavi) | http://WebWeb.ca
 * @see http://stackoverflow.com/questions/742013/how-to-code-a-url-shortener/10386945#10386945
 */
class App_Shorty {
    /**
     * Explicitely omitted: i, o, 1, 0 because they are confusing. Also use only lowercase ... as
     * dictating this over the phone might be tough.
     * @var string
     */
    private $dictionary = "abcdfghjklmnpqrstvwxyz23456789";
    private $dictionary_array = array();
    
    public function __construct() {
        $this->dictionary_array = str_split($this->dictionary);
    }

    /**
     * Gets ID and converts it into a string.
     * @param int $id
     */
    public function encode($id) {
        $str_id = '';
        $base = count($this->dictionary_array);

        while ($id > 0) {
            $rem = $id % $base;
            $id = ($id - $rem) / $base;
            $str_id .= $this->dictionary_array[$rem];
        }

        return $str_id;
    }

    /**
     * Converts /abc into an integer ID 
     * @param string
     * @return int $id
     */
    public function decode($str_id) {
        $id = 0;
        $id_ar = str_split($str_id);
        $base = count($this->dictionary_array);

        for ($i = count($id_ar); $i > 0; $i--) {
            $id += array_search($id_ar[$i - 1], $this->dictionary_array) * pow($base, $i - 1);
        }

        return $id;
    }
}
