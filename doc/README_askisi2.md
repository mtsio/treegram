Τι άλλαξε.

Απο την παλιά άσκηση άλλαξε

Η απόδοση των εικόνων στο index του χρηστη.
- Μόνο τελευταία εικόνα
- Γρουπ εικόνων με ανά ακόλουθω χρηστη
- Κάθε εικόνα είναι ορισμένη με ένα βοηθητικο συνδεσμο με τον οποιο καλούμε το url για τις εικόνες του χρήστη αυτου
- Στο hover αναδύουμε ενα slider window με τις εικόνες αυτές του ανάλογου χρηστη (κωδικας slider.js).
- Στα slides έχουμε επίσης βοηθητικους συνδέσμους για την συλλογή των comments για την αντίσοτιχη εικόνα
- στο κλικ ενος σλαιντ σταματαμε το interval που ορίσαμε και ετσι το animation σταματα. Επειτα με την βπηθεια του συνδέσμου συλ΄έγουμε τα σχόλια και τα δειχνουμε  (κωδικας popup.js).


-----
Αλλαγές γενικά σε αρχεία

### Ruby Part
 - Group the images per user (controllers/users_controller.rb)
```ruby
    @photosRes = @photosRes.flatten.sort {|a,b| b[:photo].created_at \
                                          <=> a[:photo].created_at}
                   .group_by{ |a| a[:photo].user_id }
```
 - Show last image only (views/users/show.html.haml)
 ```html
   - @photosRes.each do |group|
    - p = group[1].first 
 ``` 
 - Add slides url endpoint to retrieve the photos slides html in asc order (controllers/user_controller.rb) & (routes.rb)
 ```ruby
   # controller
   def slides
    @users = User.all
    @user = User.find(params[:id])
    @followingUsers = @user.relations.all

    @photosRes = Array.new
    @photosRes << @user.photos
          .flat_map {|p| {:email => @user.email, :photo => p}}

    @photosRes = @photosRes.flatten.sort{|a,b| b[:photo].created_at \
                                          <=> a[:photo].created_at}
    @comment = Comment.new
  end

  #route
    resources :users do
      member do
      get 'slides'
    end
```

 - Add photo comments url endpoint and html
 ```ruby
 # routes
   resources :photos do
    resources :comments
  end

#controller controllers/comments.rb#index
  def index
    @comments = Comment.all
    if params['photo_id']
      @photo = Photo.find(params[:photo_id])
      @comment = Comment.new
    end
  end
 ```

 ### Javascript Part
 - Αρχειο slider.js & slider.scss
 > Αρχικά όπως και στο popup κάνουμε προθηκη ενος div element στο body dom. Έπειτα το χρησημοποιούμε ως αναφορά για να το γεμίσουμε περιεχόμενο (onlclick κανουμε fetch τα images και το δειχνουμε). Το style είναι παρόμοιο με το popup με την διαφορά ότι ζητάμε το εξής για τον slider:
 > Όλα τα list items (li), slides να έχουν ένα στανταρ μεθεγος αλλά και μονο το πρώτο να ειναι εμφανές στο χρηστη. Έτσι μπορούμε να κάνουμε κάτι σαν slide όταν κρύβουμε σταδιακά το ένα και εμφανιζουμε το αλλό. Αυτό επιτυγχάνεται μεσω της javascript (βλεπε Slider.move).
 >Ταυτόχρονα ξεκινάμε έναν setInterval για να κάνει αυτή τη κίνηση περιοδικά (3 δευτερα).

 > ΤIP:  Στο κλικ ενος slides κάνουμε απαυεθείας χρηση το Photo.getPhotoInfo. Αυτο δηλαδή θα συλλέξει και θα μας δειξει ασυχρονα τα σχόλια της εικόνας.

  - Αρχειο popup.js & popup.scss
> Σε αυτή τη περίπτωση εδώ, σε αντιθεση με το  ροττεν  ποτειτος δεν δείχνουμε αοπαυθείας το popup. αλλά μόνο εφοσον το καλέσει ενα Slider. Η λογική ειναι παρομοια όμως, δηλαδή φορτώνουμε τα σχόλια με ajax,και επειτα τα δειχνουμε. Σε περίπτωση που κανουμε προσθήκη ενός σχολιου η το κλείσουμε, καλούμε την συνλαρτηση Slider.startShow να ξεκινησει πάλι το interval των move slides.

  - Αρχειο comment-form.js
  > Εδώ κάνουμε ασύγχρονο κληση στο service για προσθηκη σχολίου και αφου γίνει καλούμε την συνα΄ρτηση 'cb' (callback) η οποία έχει δοθεί στο popup.js (kleinei to window)
