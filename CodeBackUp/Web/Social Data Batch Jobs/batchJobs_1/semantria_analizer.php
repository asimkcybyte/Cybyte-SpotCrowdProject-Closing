<?php
require_once('session_callback_handler.php');

// the consumer key and secret
define('CONSUMER_KEY', "86f6e98d-17c0-4e91-b66d-866fa3855700");
define('CONSUMER_SECRET', "83413ca0-3bb6-4d15-8a7e-ce7a2b2823e3");

//define('CONSUMER_KEY', "aa47076d-4ac4-4b1e-b2b7-06552e4aa026");
//define('CONSUMER_SECRET', "1ac14c13-df1e-42d5-8f96-39b2eef61fd9");

class SemantriaAnalyser {
    function analyzeData($initialTexts)
    {
        // Initializes new session with the serializer object and the keys.
        $session = new \Semantria\Session(CONSUMER_KEY, CONSUMER_SECRET, NULL, NULL, TRUE);
        // Initialize session callback handler
        $callback = new SessionCallbackHandler();
        $session->setCallbackHandler($callback);
        foreach ($initialTexts as $text) {

            // Creates a sample document which need to be processed on Semantria
            // Unique document ID
            // Source text which need to be processed
            $doc = array("id" => $text["id"], "text" => $text["text"]);
            // Queues document for processing on Semantria service
            $status = $session->queueDocument($doc);
            // Check status from Semantria service
            if ($status == 202) {
                echo "Document ", $doc["id"], " queued successfully.", "\r\n";
            }
        }

        // Count of the sample documents which need to be processed on Semantria
        $length = count($initialTexts);
        $results = array();

        //while (count($results) < $length) {
            echo "Please wait 10 sec for documents ...", "\r\n";
            // As Semantria isn't real-time solution you need to wait some time before getting of the processed results
            // In real application here can be implemented two separate jobs, one for queuing of source data another one for retreiving
            // Wait ten seconds while Semantria process queued document
            sleep(10);

            // Requests processed results from Semantria service
            $status = $session->getProcessedDocuments();
            // Check status from Semantria service
            if (is_array($status)) {
                $results = array_merge($results, $status);
            }
            echo count($status), " documents received successfully.", "\r\n";
        //}

        $analyzedArray = array();
        foreach ($results as $data) {
            // Printing of document sentiment score
            //echo "Document ", $data["id"], " Sentiment score: ", $data["sentiment_score"], "\r\n";
            $analyzedArray[] = array( 'id' => $data["id"],	'score' => $data["sentiment_score"]);

        }
        return $analyzedArray;
    }
    
    function analyzeProjectData($initialTexts)
    {
    	// Initializes new session with the serializer object and the keys.
    	$session = new \Semantria\Session(CONSUMER_KEY, CONSUMER_SECRET, NULL, NULL, TRUE);
    	// Initialize session callback handler
    	$callback = new SessionCallbackHandler();
    	$session->setCallbackHandler($callback);
    	foreach ($initialTexts as $text) {
    
    		// Creates a sample document which need to be processed on Semantria
    		// Unique document ID
    		// Source text which need to be processed
    		if($text["comments"]!=null && $text["comments"]!=""){
    			$doc = array("id" => $text["id"]."____".$text["project_id"], "text" => $text["comments"]);
    		
	    		// Queues document for processing on Semantria service
	    		$status = $session->queueDocument($doc);
	    		// Check status from Semantria service
	    		if ($status == 202) {
	    			echo "Document ", $doc["id"], " queued successfully.", "\r\n";
	    		}
    		}
    	}
    
    	// Count of the sample documents which need to be processed on Semantria
    	$length = count($initialTexts);
    	$results = array();
    	$sementriaTimes = 0;
    	//while (count($results) < $length) {
    		echo "Please wait 10 sec for documents ...", "\r\n";
    		// As Semantria isn't real-time solution you need to wait some time before getting of the processed results
    		// In real application here can be implemented two separate jobs, one for queuing of source data another one for retreiving
    		// Wait ten seconds while Semantria process queued document
    		sleep(10);
    		$sementriaTimes .= $sementriaTimes+1;
    		// Requests processed results from Semantria service
    		$status = $session->getProcessedDocuments();
    		// Check status from Semantria service
    		if (is_array($status)) {
    			$results = array_merge($results, $status);
    		}
    		if($sementriaTimes > 2){
    			$length = count($results);
    		}
    		echo count($status), " documents received successfully.", "\r\n";
    	//}
    
    	$analyzedArray = array();
    	foreach ($results as $data) {
    		// Printing of document sentiment score
    		//echo "Document ", $data["id"], " Sentiment score: ", $data["sentiment_score"], "\r\n";
    		$analyzedArray[] = array( 'id' => $data["id"],	'score' => $data["sentiment_score"]);
    
    	}
    	return $analyzedArray;
    }
}

?>