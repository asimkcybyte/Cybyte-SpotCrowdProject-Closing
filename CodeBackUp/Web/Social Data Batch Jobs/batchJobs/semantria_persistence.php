<?php

class SemantriaPagePersistence
{
    var $m_persistence;

    function SemantriaPagePersistence()
    {
    	$this->m_persistence = new BatchPersistence();
    	$this->m_persistence->BatchPersistenceSetup();
    }


    function GetSentimentAnalysysData()
    {
        $sa_data = array();
        //$selQuery = "select * from scf_user_pov_comments where scfupov_bplnmps_id = $bplnmps_id";
        $selQuery = "select * from scf_user_pov_comments where DATE(scfupov_create_date) = CURDATE() and scfupov_comment_value !='' and scfupov_pov_value != ''";
        $this->m_persistence->SelectQuery($selQuery);
        if(count($this->m_persistence->m_data_rows ) >0)
        {
        	echo "inside";
            foreach ($this->m_persistence->m_data_rows as $row_data)
            {
                $sa_data[] = array("id"=>$row_data["scfupov_id"],"text"=>$row_data["scfupov_pov_value"]);
            }
        }
        return $sa_data;
    }
    function GetBpSentimentAnalysysData()
    {
        $sa_data = array();
        //$selQuery = "select * from scf_user_pov_comments where scfupov_bplnmps_id = $bplnmps_id";
        $selQuery = "select * from bplnm_keywords_sentences where DATE(bplnmkeysen_create_date) = CURDATE() and bplnmkeysen_value !=''";
        $this->m_persistence->SelectQuery($selQuery);
        if(count($this->m_persistence->m_data_rows ) >0)
        {
        	echo "inside";
            foreach ($this->m_persistence->m_data_rows as $row_data)
            {
                $sa_data[] = array("id"=>$row_data["bplnmkeysen_id"],"text"=>$row_data["bplnmkeysen_value"]);
            }
        }
        return $sa_data;
    }
    function GetSentimentAnalysysDataForGooglePlus()
    {
    	$sa_data = array();
    	$selQuery = "select * from tbl_googleplus_comments where DATE(publish) = CURDATE() and content != ''";
    	$this->m_persistence->SelectQuery($selQuery);
    	if(count($this->m_persistence->m_data_rows ) >0)
    	{
    		foreach ($this->m_persistence->m_data_rows as $row_data)
    		{
    			$sa_data[] = array("id"=>$row_data["id"],"project_id"=>$row_data["project_id"],"comments"=>$row_data["content"]);
    		}
    	}
    	return $sa_data;
    }
    
    function GetSentimentAnalysysDataForLinkedIn()
    {
    	$sa_data = array();
    	$selQuery = "select * from tbl_googleplus_comments where DATE(publish) = CURDATE()";
    	$this->m_persistence->SelectQuery($selQuery);
    	if(count($this->m_persistence->m_data_rows ) >0)
    	{
    		foreach ($this->m_persistence->m_data_rows as $row_data)
    		{
    			$sa_data[] = array("id"=>$row_data["id"],"project_id"=>$row_data["project_id"],"comments"=>$row_data["content"]);
    		}
    	}
    	return $sa_data;
    }
    
    function GetSentimentAnalysysDataForYoutube()
    {
    	$sa_data = array();
    	$selQuery = "select * from tbl_youtube_video_comments where DATE(posted_date) = CURDATE()  and comment_text != ''";
    	$this->m_persistence->SelectQuery($selQuery);
    	if(count($this->m_persistence->m_data_rows ) >0)
    	{
    		foreach ($this->m_persistence->m_data_rows as $row_data)
    		{
    			$sa_data[] = array("id"=>$row_data["id"],"project_id"=>$row_data["project_id"],"comments"=>$row_data["comment_text"]);
    		}
    	}
    	return $sa_data;
    }
    
    function GetSentimentAnalysysDataForWordpress()
    {
    	$sa_data = array();
    	$selQuery = "select * from wp_blog_feed_comment where DATE(publishdate) = CURDATE() and title != '' and description != ''";
    	$this->m_persistence->SelectQuery($selQuery);
    	if(count($this->m_persistence->m_data_rows ) >0)
    	{
    		foreach ($this->m_persistence->m_data_rows as $row_data)
    		{
    			$sa_data[] = array("id"=>$row_data["id"],"project_id"=>$row_data["project_id"],"comments"=>$row_data["description"]);
    		}
    	}
    	return $sa_data;
    }
    
    function GetSentimentAnalysysDataForFaceBook()
    {
    	$sa_data = array();
    	$selQuery = "select * from tbl_facebook_user_post_comments where DATE(created_time) = CURDATE() and message != ''";
    	$this->m_persistence->SelectQuery($selQuery);
    	if(count($this->m_persistence->m_data_rows ) >0)
    	{
    		foreach ($this->m_persistence->m_data_rows as $row_data)
    		{
    			$sa_data[] = array("id"=>$row_data["id"],"project_id"=>$row_data["page_post_id"],"comments"=>$row_data["message"]);
    		}
    	}
    	return $sa_data;
    }
    
    function GetSentimentAnalysysDataForTwitter()
    {
    	$sa_data = array();
    	$selQuery = "select * from tbl_twitter_data where DATE(tweetdate) = CURDATE() and tweet != ''";
    	$this->m_persistence->SelectQuery($selQuery);
    	if(count($this->m_persistence->m_data_rows ) >0)
    	{
    		foreach ($this->m_persistence->m_data_rows as $row_data)
    		{
    			$sa_data[] = array("id"=>$row_data["id"],"project_id"=>$row_data["project_id"],"comments"=>$row_data["tweet"]);
    		}
    	}
    	return $sa_data;
    }
    
    function GetSentimentAnalysysDataForReddit()
    {
    	$sa_data = array();
    	$selQuery = "select * from tbl_subreddit_data where DATE(created) = CURDATE() and selftext != ''";
    	$this->m_persistence->SelectQuery($selQuery);
    	if(count($this->m_persistence->m_data_rows ) >0)
    	{
    		foreach ($this->m_persistence->m_data_rows as $row_data)
    		{
    			$sa_data[] = array("id"=>$row_data["id"],"project_id"=>$row_data["project_id"],"comments"=>$row_data["selftext"]);
    		}
    	}
    	return $sa_data;
    }
    
    function GetSentimentAnalysysDataForInstagram()
    {
    	$sa_data = array();
    	$selQuery = "select * from tbl_instagram_data where DATE(inserttime) = CURDATE() and bio != ''";
    	$this->m_persistence->SelectQuery($selQuery);
    	if(count($this->m_persistence->m_data_rows ) >0)
    	{
    		foreach ($this->m_persistence->m_data_rows as $row_data)
    		{
    			$sa_data[] = array("id"=>$row_data["id"],"project_id"=>$row_data["project_id"],"comments"=>$row_data["bio"]);
    		}
    	}
    	return $sa_data;
    }
    
    function UpdateAnalyzedData($analyzedArray)
    {
    	$sql_query = "UPDATE scf_user_pov_comments SET scfupov_score = CASE scfupov_id";    	
    	$inQuery = "";
    	$length = count($analyzedArray);
    	$i = 1;
    	foreach ($analyzedArray as $text) {   		
    		$sql_query .= " WHEN ".$text["id"]." THEN ".$text["score"];
    		if($i<$length){
    			$inQuery .= $text["id"].", ";
    		}else{
    			$inQuery .= $text["id"];
    		}
    		$i++;
    	}
    	$sql_query .= " END WHERE scfupov_id IN ( ".$inQuery." ) ";    	
    	$id = $this->m_persistence->ExecuteQuery($sql_query);
    	return $id;
    }
    
    function UpdateBPAnalyzedData($analyzedArray)
    {
    	$sql_query = "UPDATE bplnm_keywords_sentences SET bplnmkeysen_score = CASE bplnmkeysen_id";    	
    	$inQuery = "";
    	$length = count($analyzedArray);
    	$i = 1;
    	foreach ($analyzedArray as $text) {   		
    		$sql_query .= " WHEN ".$text["id"]." THEN ".$text["score"];
    		if($i<$length){
    			$inQuery .= $text["id"].", ";
    		}else{
    			$inQuery .= $text["id"];
    		}
    		$i++;
    	}
    	 $sql_query .= " END WHERE bplnmkeysen_id IN ( ".$inQuery." ) ";    	
    	$id = $this->m_persistence->ExecuteQuery($sql_query);
    	return $id;
    }
	
	//-----venu---->
	function UpdateTHEMESAnalyzedData($analyzedArray)
    {
		foreach ($analyzedArray as $text) 
		{
			//$myArray = explode('____', $text["id"]);
			$id 	= $text['id'];
			$themes 	= $text['themes'];
			foreach($themes as $theme)
			{
				$theme_score = $theme['sentiment_score'];
				$theme_title = $theme['title'];
				$sql_query = "INSERT INTO tbl_sentiment_score_themes (bplnmkeysen_id, themes_value, themes_score, Created_date) VALUES ( " . $id . ", '" . $theme_title  . "', " . $theme_score . ", NOW()  )";
				$this->m_persistence->ExecuteQuery($sql_query);
			}			
		}
		
    }
	
	function UpdateENTITIESAnalyzedData($analyzedArray)
    {
		foreach ($analyzedArray as $text) 
		{
			//$myArray = explode('____', $text["id"]);
			$id 	= $text['id'];
			$entities 	= $text['entities'];
			foreach($entities as $entity)
			{
				$entity_score = $entity['sentiment_score'];
				$entity_title = $entity['title'];
				$sql_query = "INSERT INTO tbl_sentiment_score_entities (bplnmkeysen_id, entities_value, entities_score, Created_date) VALUES ( " . $id . ", '" . $entity_title  . "', " . $entity_score . ", NOW()  )";
				$this->m_persistence->ExecuteQuery($sql_query);
			}			
		}
    }
	
	function UpdatePHRASESAnalyzedData($analyzedArray)
    {
		foreach ($analyzedArray as $text) 
		{
			//$myArray = explode('____', $text["id"]);
			$id 	= $text['id'];
			$phrases 	= $text['phrases'];
			foreach($phrases as $entity)
			{
				$phrase_score = $entity['sentiment_score'];
				$phrase_title = $entity['title'];
				$sql_query = "INSERT INTO tbl_sentiment_score_phrases (bplnmkeysen_id, phrases_value, phrases_score, Created_date) VALUES ( " . $id . ", '" . $phrase_title  . "', " . $phrase_score . ", NOW()  )";
				$this->m_persistence->ExecuteQuery($sql_query);
			}			
		}
    }
	//------venu----->
	
	
	
    function UpdateGooglePlusAnalyzedData($analyzedArray)
    {
    	$social_media_id = 1;
    	foreach ($analyzedArray as $text) {
    		$myArray = explode('____', $text["id"]);
    		$sql_query = "INSERT INTO tbl_sementria_score (prj_id,social_media_id, Date, Semtria_score) VALUES ( " . $myArray[1] . ", " . $social_media_id . ", NOW(),". $text["score"] . " )";
    		$this->m_persistence->ExecuteQuery($sql_query);
    	}
    }

    function UpdateWordpressAnalyzedData($analyzedArray)
    {
    	$social_media_id = 2;
    	foreach ($analyzedArray as $text) {
    		$myArray = explode('____', $text["id"]);
    		$sql_query = "INSERT INTO tbl_sementria_score (prj_id,social_media_id, Date, Semtria_score) VALUES ( " . $myArray[1] . ", " . $social_media_id . ", NOW(),". $text["score"] . " )";
    		$this->m_persistence->ExecuteQuery($sql_query);
    	}
    }

    function UpdateYouTubeAnalyzedData($analyzedArray)
    {
    	$social_media_id = 3;
    	foreach ($analyzedArray as $text) {
    		$myArray = explode('____', $text["id"]);
    		$sql_query = "INSERT INTO tbl_sementria_score (prj_id,social_media_id, Date, Semtria_score) VALUES ( " . $myArray[1] . ", " . $social_media_id . ", NOW(),". $text["score"] . " )";
    		$this->m_persistence->ExecuteQuery($sql_query);
    	}
    }
    
    function UpdateLinkedInAnalyzedData($analyzedArray)
    {
        $social_media_id = 4;
    	foreach ($analyzedArray as $text) {
    		$myArray = explode('____', $text["id"]);
    		$sql_query = "INSERT INTO tbl_sementria_score (prj_id,social_media_id, Date, Semtria_score) VALUES ( " . $myArray[1] . ", " . $social_media_id . ", NOW(),". $text["score"] . " )";
    		$this->m_persistence->ExecuteQuery($sql_query);
    	}
    }
    
    function UpdateFaceBookAnalyzedData($analyzedArray)
    {
    	$social_media_id = 5;
    	foreach ($analyzedArray as $text) {
    		$myArray = explode('____', $text["id"]);
    		$sql_query = "INSERT INTO tbl_sementria_score (prj_id,social_media_id, Date, Semtria_score) VALUES ( " . $myArray[1] . ", " . $social_media_id . ", NOW(),". $text["score"] . " )";
    		$this->m_persistence->ExecuteQuery($sql_query);
    	}
    }
    
    function UpdateTwitterAnalyzedData($analyzedArray)
    {
    	$social_media_id = 6;
    	foreach ($analyzedArray as $text) {
    		$myArray = explode('____', $text["id"]);
    		$sql_query = "INSERT INTO tbl_sementria_score (prj_id,social_media_id, Date, Semtria_score) VALUES ( " . $myArray[1] . ", " . $social_media_id . ", NOW(),". $text["score"] . " )";
    		$this->m_persistence->ExecuteQuery($sql_query);
    	}
    }
    
    function UpdateRedditAnalyzedData($analyzedArray)
    {
    	$social_media_id = 7;
    	foreach ($analyzedArray as $text) {
    		$myArray = explode('____', $text["id"]);
    		$sql_query = "INSERT INTO tbl_sementria_score (prj_id,social_media_id, Date, Semtria_score) VALUES ( " . $myArray[1] . ", " . $social_media_id . ", NOW(),". $text["score"] . " )";
    		$this->m_persistence->ExecuteQuery($sql_query);
    	}
    }
    
    function UpdateInstagramAnalyzedData($analyzedArray)
    {
    	$social_media_id = 8;
    	foreach ($analyzedArray as $text) {
    		$myArray = explode('____', $text["id"]);
    		$sql_query = "INSERT INTO tbl_sementria_score (prj_id,social_media_id, Date, Semtria_score) VALUES ( " . $myArray[1] . ", " . $social_media_id . ", NOW(),". $text["score"] . " )";
    		$this->m_persistence->ExecuteQuery($sql_query);
    	}
    }
}
?>